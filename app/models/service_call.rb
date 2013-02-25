# == Schema Information
#
# Table name: tickets
#
#  id                   :integer         not null, primary key
#  customer_id          :integer
#  notes                :text
#  started_on           :datetime
#  organization_id      :integer
#  completed_on         :datetime
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  status               :integer
#  subcontractor_id     :integer
#  technician_id        :integer
#  provider_id          :integer
#  subcontractor_status :integer
#  type                 :string(255)
#  ref_id               :integer
#  creator_id           :integer
#  updater_id           :integer
#  settled_on           :datetime
#  billing_status       :integer
#  settlement_date      :datetime
#  name                 :string(255)
#  scheduled_for        :datetime
#  transferable         :boolean         default(FALSE)
#  allow_collection     :boolean         default(TRUE)
#  collector_id         :integer
#  collector_type       :string(255)
#  provider_status      :integer
#  work_status          :integer
#  re_transfer          :boolean
#

class ServiceCall < Ticket


  # if im not the subcontractor of this service call then I'm the provider
  def my_role
    if subcontractor_id.nil?
      if provider_id.nil?
        @my_role = :prov
      else
        @my_role = :subcon
      end
    else
      @my_role ||= self.organization_id == self.subcontractor_id ? :subcon : :prov

    end
  end


# State machine  for ServiceCall status
# first we will define the service call state values


  def init_state_machines
    initialize_state_machines
  end


  WORK_STATUS_PENDING     = 2000
  WORK_STATUS_DISPATCHED  = 2001
  WORK_STATUS_IN_PROGRESS = 2002
  WORK_STATUS_ACCEPTED    = 2003
  WORK_STATUS_REJECTED    = 2004
  WORK_STATUS_DONE        = 2005

  state_machine :work_status, initial: :pending, namespace: 'work' do
    state :pending, value: WORK_STATUS_PENDING
    state :dispatched, value: WORK_STATUS_DISPATCHED do
      validate {|sc| sc.validate_technician }
    end
    state :in_progress, value: WORK_STATUS_IN_PROGRESS do
      validate {|sc| sc.validate_technician }
    end
    state :accepted, value: WORK_STATUS_ACCEPTED
    state :rejected, value: WORK_STATUS_REJECTED
    state :done, value: WORK_STATUS_DONE

    after_failure do |service_call, transition|
      Rails.logger.debug { "#{service_call.class.name} work status state machine failure. errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect + "\n The Service Call:" + service_call.inspect}
    end

    event :start do
      transition [:pending] => :in_progress, if: lambda { |sc| !sc.organization.multi_user? && !sc.transferred? }
      transition [:accepted, :dispatched] => :in_progress
    end

    event :accept do
      transition :pending => :accepted, if: lambda { |sc| sc.transferred? }
    end

    event :reject do
      transition :pending => :rejected, if: lambda { |sc| sc.transferred? }
    end

    event :un_accept do
      transition :accepted => :rejected, if: lambda { |sc| sc.transferred? }
    end

    event :dispatch do
      transition :pending => :dispatched, if: lambda { |sc| sc.organization.multi_user? }
    end

    event :reset do
      transition :rejected => :pending
    end

    event :complete do
      transition :in_progress => :done
    end

  end

  # State machine for ServiceCall subcontractor_status
  # status constant list:
  SUBCON_STATUS_NA                 = 3000
  SUBCON_STATUS_PENDING            = 3001
  SUBCON_STATUS_CLAIM_SETTLED      = 3002
  SUBCON_STATUS_CLAIMED_AS_SETTLED = 3003
  SUBCON_STATUS_SETTLED            = 3004

  state_machine :subcontractor_status, :initial => :na, namespace: 'subcon' do
    state :na, value: SUBCON_STATUS_NA
    state :pending, value: SUBCON_STATUS_PENDING
    state :claim_settled, value: SUBCON_STATUS_CLAIM_SETTLED do
      validate { |sc| sc.subcon_settlement_allowed? }
    end
    state :claimed_as_settled, value: SUBCON_STATUS_CLAIMED_AS_SETTLED do
      validate { |sc| sc.subcon_settlement_allowed? }
    end
    state :settled, value: SUBCON_STATUS_SETTLED do
      validate { |sc| sc.subcon_settlement_allowed? }
    end

    after_failure do |service_call, transition|
      Rails.logger.debug { "Service Call subcon status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    event :subcon_confirmed do
      transition :claim_settled => :settled , if: lambda {|sc| sc.subcon_settlement_allowed?}
    end

    event :subcon_marked_as_settled do
      transition :pending => :claimed_as_settled, if: lambda { |sc| sc.subcontractor.subcontrax_member? && sc.subcon_settlement_allowed? }
    end

    event :confirm_settled do
      transition :claimed_as_settled => :settled, if: lambda {|sc| sc.subcon_settlement_allowed?}
    end

    event :settle do
      transition :pending => :settled, if: lambda { |sc| sc.subcon_settlement_allowed? && sc.work_done? && !sc.subcontractor.subcontrax_member? }
      transition :pending => :claim_settled, if: lambda { |sc| sc.subcon_settlement_allowed? && sc.work_done? && sc.subcontractor.subcontrax_member? }
    end
  end


  def set_type
    case my_role
      when :prov
        self.type = "MyServiceCall"
        self.becomes(MyServiceCall).init_state_machines
      when :subcon
        self.type = "TransferredServiceCall"
        self.becomes(TransferredServiceCall).init_state_machines
      else
        raise "Unexpected result received from service_call.my_role"
    end
  end

  def self.new_from_params(org, params)
    if params.empty?
      sc = ServiceCall.new
    else

      if params[:provider_id].empty? || params[:provider_id] == org.id
        sc = MyServiceCall.new(params)
      else
        sc = TransferredServiceCall.new(params)
      end

    end
    sc.organization = org
    sc
  end


  def subcon_settlement_allowed?

    (subcontractor.subcontrax_member? && !allow_collection?) ||
        (subcontractor.subcontrax_member? && allow_collection? && payment_paid?) ||
        ( !subcontractor.subcontrax_member? && work_done?)
  end

end

