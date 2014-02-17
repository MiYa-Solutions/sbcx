# == Schema Information
#
# Table name: tickets
#
#  id                    :integer          not null, primary key
#  customer_id           :integer
#  notes                 :text
#  started_on            :datetime
#  organization_id       :integer
#  completed_on          :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :integer
#  subcontractor_id      :integer
#  technician_id         :integer
#  provider_id           :integer
#  subcontractor_status  :integer
#  type                  :string(255)
#  ref_id                :integer
#  creator_id            :integer
#  updater_id            :integer
#  settled_on            :datetime
#  billing_status        :integer
#  settlement_date       :datetime
#  name                  :string(255)
#  scheduled_for         :datetime
#  transferable          :boolean          default(TRUE)
#  allow_collection      :boolean          default(TRUE)
#  collector_id          :integer
#  collector_type        :string(255)
#  provider_status       :integer
#  work_status           :integer
#  re_transfer           :boolean          default(TRUE)
#  payment_type          :string(255)
#  subcon_payment        :string(255)
#  provider_payment      :string(255)
#  company               :string(255)
#  address1              :string(255)
#  address2              :string(255)
#  city                  :string(255)
#  state                 :string(255)
#  zip                   :string(255)
#  country               :string(255)
#  phone                 :string(255)
#  mobile_phone          :string(255)
#  work_phone            :string(255)
#  email                 :string(255)
#  subcon_agreement_id   :integer
#  provider_agreement_id :integer
#  tax                   :float            default(0.0)
#  subcon_fee_cents      :integer          default(0), not null
#  subcon_fee_currency   :string(255)      default("USD"), not null
#  properties            :hstore
#

class ServiceCall < Ticket

  def fully_paid?(options = {})
    current_payment = payment_amount || 0

    if options[:work_in_progress].nil?
      work_done? ? total + (paid_amount - Money.new(current_payment.to_f * 100, total.currency)) <= 0 : false
    else
      total > 0 ? total + (paid_amount - Money.new(current_payment.to_f * 100, total.currency)) <=0 : false
    end

  end

  attr_accessor :payment_amount
  validate :financial_data_change

  def my_role
    if self.organization_id == self.subcontractor_id # am I the subcontractor?
      @my_role = :subcon
    elsif self.organization_id == self.provider_id # am I the provider?
      @my_role = :prov
    else # if I'm not the provider and not the subcontractor then I'm a broker
      @my_role = :broker
    end
  end


# State machine  for ServiceCall status
# first we will define the service call state values


  def init_state_machines
    initialize_state_machines
  end

  scope :my_transferred_jobs, ->(org) { where("tickets.organization_id = ?", org.id).transferred_status }
  scope :jobs_to_work_on, ->(org) { where("tickets.organization_id = ?", org.id) & (new_status | open_status | where("tickets.status = ?", TransferredServiceCall::STATUS_ACCEPTED)) }
  scope :open_jobs, ->(org) { where('tickets.organization_id = ?', org.id).where('tickets.status NOT IN (?)', [STATUS_CLOSED, STATUS_CANCELED]) }

  WORK_STATUS_PENDING     = 2000
  WORK_STATUS_DISPATCHED  = 2001
  WORK_STATUS_IN_PROGRESS = 2002
  WORK_STATUS_ACCEPTED    = 2003
  WORK_STATUS_REJECTED    = 2004
  WORK_STATUS_DONE        = 2005

  state_machine :work_status, initial: :pending, namespace: 'work' do
    state :pending, value: WORK_STATUS_PENDING
    state :dispatched, value: WORK_STATUS_DISPATCHED do
      validate { |sc| sc.validate_technician }
    end
    state :in_progress, value: WORK_STATUS_IN_PROGRESS do
      validate { |sc| sc.validate_technician }
    end
    state :accepted, value: WORK_STATUS_ACCEPTED
    state :rejected, value: WORK_STATUS_REJECTED
    state :done, value: WORK_STATUS_DONE

    after_transition any => :done do |sc, transition|
      sc.check_and_set_as_fully_paid
    end

    after_failure do |service_call, transition|
      Rails.logger.debug { "#{service_call.class.name} work status state machine failure. errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect + "\n The Service Call:" + service_call.inspect }
    end

    event :start do
      transition [:pending] => :in_progress, if: lambda { |sc| !sc.canceled? && !sc.organization.multi_user? && !sc.transferred? }
      transition [:accepted, :dispatched] => :in_progress, if: ->(sc) { !sc.canceled? }
    end

    event :accept do
      transition :pending => :accepted, if: lambda { |sc| !sc.canceled? && sc.transferred? }
    end

    event :reject do
      transition :pending => :rejected, if: lambda { |sc| !sc.canceled? && sc.transferred? }
    end

    # todo reinstate once we decide to implement the un_accept event
    #event :un_accept do
    #  transition :accepted => :rejected, if: lambda { |sc| !sc.canceled? && sc.transferred? }
    #end

    event :dispatch do
      transition :pending => :dispatched, if: ->(sc) { !sc.canceled? && sc.organization.multi_user? && !sc.transferred? }
    end

    event :reset do
      transition :rejected => :pending, if: ->(sc) { !sc.canceled? }
    end

    event :complete do
      transition :in_progress => :done, if: ->(sc) { !sc.canceled? }
    end

  end

  # State machine for ServiceCall subcontractor_status
  # status constant list:
  SUBCON_STATUS_NA                 = 3000
  SUBCON_STATUS_PENDING            = 3001
  SUBCON_STATUS_CLAIM_SETTLED      = 3002
  SUBCON_STATUS_CLAIMED_AS_SETTLED = 3003
  SUBCON_STATUS_SETTLED            = 3004
  SUBCON_STATUS_CLEARED            = 3005

  state_machine :subcontractor_status, :initial => :na, namespace: 'subcon' do
    state :na, value: SUBCON_STATUS_NA
    state :pending, value: SUBCON_STATUS_PENDING
    state :claim_settled, value: SUBCON_STATUS_CLAIM_SETTLED do
      # todo validate that the payment string is valid
      validates_presence_of :subcon_payment
    end
    state :claimed_as_settled, value: SUBCON_STATUS_CLAIMED_AS_SETTLED do
      validates_presence_of :subcon_payment
    end
    state :settled, value: SUBCON_STATUS_SETTLED do
      validates_presence_of :subcon_payment
    end
    state :cleared, value: SUBCON_STATUS_CLEARED do
      validates_presence_of :subcon_payment
    end

    after_failure do |service_call, transition|
      Rails.logger.debug { "Service Call subcon status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    after_transition any => :settled do |service_call, transition|
      if service_call.subcon_payment == 'cash'
        service_call.subcontractor_status = SUBCON_STATUS_CLEARED
        service_call.save
      end
    end

    event :subcon_confirmed do
      transition :claim_settled => :settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? }
    end

    event :subcon_marked_as_settled do
      transition :pending => :claimed_as_settled, if: ->(sc) { !sc.canceled? && sc.subcontractor.subcontrax_member? && sc.subcon_settlement_allowed? }
    end

    event :confirm_settled do
      transition :claimed_as_settled => :settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? }
    end

    event :settle do
      transition :pending => :settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? && sc.work_done? && !sc.subcontractor.subcontrax_member? }
      transition :pending => :claim_settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? && sc.work_done? && sc.subcontractor.subcontrax_member? }
    end

    event :clear do
      transition :settled => :cleared
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
      params[:organization_id] = org.id
      if params[:provider_id].empty? || params[:provider_id] == org.id
        sc = MyServiceCall.new(params)
      else
        params[:subcontractor_id] = nil
        sc                        = TransferredServiceCall.new(params)
      end

    end
    #sc.organization = org
    sc
  end

  def as_json(options = {})
    {
        tag_list:      tag_list,
        provider:      [provider],
        subcontractor: [subcontractor]
    }
  end


  def subcon_settlement_allowed?

    (subcontractor.subcontrax_member? && !allow_collection?) ||
        (subcontractor.subcontrax_member? && allow_collection? && (payment_paid?) || payment_cleared?)||
        (!subcontractor.subcontrax_member? && work_done?)
  end

  def can_change_boms?

    (self.work_status_was == WORK_STATUS_IN_PROGRESS || self.work_in_progress?)&& (!self.transferred? || self.transferred? && !self.subcontractor.subcontrax_member?)
  end

  alias_method :can_change_financial_data?, :can_change_boms?

  def invoice
    Invoice.new(self)
  end

  def already_invoiced?
    invoice.date ? true : false
  end

  def check_payment_amount
    errors.add :payment_amount, "Payment must be a number greater than zero" if self.payment_amount.nil? || self.payment_amount.try(:empty?) || self.payment_amount.to_f == 0.0
  end

  def collection_entries
    CollectionEntry.where(ticket_id: self.id)
  end

  def collected_entries
    CollectedEntry.where(ticket_id: self.id)
  end

  private
  def financial_data_change
    errors.add :tax, "Can't change tax when job is completed or transferred" if !self.system_update && self.changed_attributes.has_key?('tax') && !can_change_financial_data?
  end

end

