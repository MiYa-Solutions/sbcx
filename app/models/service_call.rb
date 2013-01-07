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
#  total_price          :decimal(, )
#  settlement_date      :datetime
#  name                 :string(255)
#  scheduled_for        :datetime
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

# common statuses for all service call types
# specific statuses will be setup in each sub-class by prefixing with an integer to avoid conflicts
# i.e. STATUS_SUBCLASS_STATUS = 41 (4 being the subclass status identifier)
  STATUS_NA          = 0
  STATUS_DISPATCHED  = 1
  STATUS_TRANSFERRED = 2
  STATUS_STARTED     = 3
  STATUS_WORK_DONE   = 4
  STATUS_SETTLED     = 5
  STATUS_IN_PROGRESS = 6
  STATUS_CANCELED    = 7


  state_machine :status, initial: :na do
    state :na, value: STATUS_NA
    after_failure do |service_call, transition|
      Rails.logger.debug { "Service Call status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

  end


  def init_state_machines
    initialize_state_machines
  end

  def next_events
    my_role == :prov ? next_provider_events : next_subcontractor_events
  end

  # State machine for ServiceCall subcontractor_status
  # status constant list:
  SUBCON_STATUS_NA          = 0
  SUBCON_STATUS_PENDING     = 1
  SUBCON_STATUS_ACCEPTED    = 2
  SUBCON_STATUS_REJECTED    = 3
  SUBCON_STATUS_TRANSFERRED = 4
  SUBCON_STATUS_IN_PROGRESS = 5
  SUBCON_STATUS_WORK_DONE   = 6
  SUBCON_STATUS_SETTLED     = 7
  SUBCON_STATUS_CANCELED    = 8
  SUBCON_STATUS_PAID        = 9

  state_machine :subcontractor_status, :initial => :na, namespace: 'subcon' do
    state :na, value: SUBCON_STATUS_NA
  end

  BILLING_STATUS_PENDING = 0
  BILLING_STATUS_PAID    = 1
  BILLING_STATUS_OVERDUE = 2

  state_machine :billing_status, initial: :pending, namespace: 'customer' do
    state :pending, value: BILLING_STATUS_PENDING
    state :paid, value: BILLING_STATUS_PAID do
      #validate :total_price_validation
    end
    state :overdue, value: BILLING_STATUS_OVERDUE do
      #validates_numericality_of :total_price
    end

    event :paid do
      transition [:pending, :overdue] => :paid
    end

    event :overdue do
      transition :pending => :overdue
    end
  end


end

