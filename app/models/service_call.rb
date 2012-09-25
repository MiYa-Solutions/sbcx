# == Schema Information
#
# Table name: service_calls
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
#

class ServiceCall < ActiveRecord::Base
  attr_accessible :customer_id, :notes, :started_on, :completed_on, :completed_on_text, :started_on_text, :new_customer, :status_event, :subcontractor, :provider_id
  belongs_to :customer, :inverse_of => :service_calls
  belongs_to :organization, :inverse_of => :service_calls
  belongs_to :subcontractor
  belongs_to :provider
  belongs_to :technician, class_name: User
  has_many :events, as: :eventable

  # virtual attributes
  attr_writer :started_on_text
  attr_writer :completed_on_text
  attr_accessor :new_customer

  # transform the dates before saving
  before_save :save_started_on_text
  before_save :save_completed_on_text
  # create a new customer in case one was asked for
  before_save :create_customer

  validate :check_completed_on_text, :check_started_on_text
  validates_presence_of :organization, :customer

  accepts_nested_attributes_for :customer

  # if im not the subcontractor of this service call then I'm the provider
  def my_role
    @my_role ||= self.organization_id == subcontractor_id ? :subcon : :prov
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


  state_machine :status, initial: :na do
    state :na, value: STATUS_NA
  end
#
# The state machine definitions
#state_machine :status, :initial => :new do
#  state :new, value: STATUS_NEW
#  state :open, value: STATUS_OPEN
#  state :closed, value: STATUS_CLOSED
#  state :dispatched, value: STATUS_DISPATCHED
#  state :in_progress, value: STATUS_IN_PROGRESS
#  state :work_done, value: STATUS_WORK_DONE
#
#  #before_transition :new => :transferred, :do => :transfer_service_call
#  #after_transition :new => :local_enabled, :do => :alert_local
#
#  event :accept do
#    transition :open => :open
#
#  end
#
#  event :transfer do
#    transition :new => :open
#  end
#
#  event :close do
#    transition :open => :closed
#  end
#
#  event :dispatch do
#    transition :new => :dispatched
#  end
#
#  event :start do
#    transition :dispatched => :in_progress
#  end
#
#  event :settle do
#    transition :work_done => :closed
#  end
#
#  event :complete do
#    transition :in_progress => :work_done
#  end
#
#
#  #def transfer(recipient, *args)
#  #  Rails.logger.debug "Transferring job to #{recipient.name}"
#  #  super
#  #end
#
#end


  def init_state_machines
    initialize_state_machines
  end

#def accept
#  subcon_accept
#  super
#end
#
#def transfer
#  self.subcontractor_status= SUBCON_STATUS_TRANSFERRED
#  super
#end

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

  #state_machine :subcontractor_status, :initial => :na, namespace: 'subcon' do
  #  state :na, value: SUBCON_STATUS_NA
  #  state :pending, value: SUBCON_STATUS_PENDING
  #  state :accepted, value: SUBCON_STATUS_ACCEPTED
  #  state :rejected, value: SUBCON_STATUS_REJECTED
  #  state :transferred, value: SUBCON_STATUS_TRANSFERRED
  #  state :in_progress, value: SUBCON_STATUS_IN_PROGRESS
  #  state :work_done, value: SUBCON_STATUS_WORK_DONE
  #  state :settled, value: SUBCON_STATUS_SETTLED
  #
  #  event :subcon_transfer do
  #    transition [:na] => :transferred
  #  end
  #
  #  event :subcon_accept do
  #    transition :transferred => :accepted
  #  end
  #  event :subcon_reject do
  #    transition :transferred => :rejected
  #  end
  #  event :subcon_start do
  #    transition [:accepted] => :in_progress
  #  end
  #  event :subcon_complete do
  #    transition [:in_progress] => :work_done
  #  end
  #  event :subcon_settle do
  #    transition [:work_done] => :settled
  #  end
  #
  #end

  def completed_on_text
    @completed_on_text || completed_on.try(:strftime, "%Y-%m-%d %H:%M:%S")

  end

  def save_completed_on_text
    self.completed_on = Time.zone.parse(@completed_on_text) if @completed_on_text.present?
  end

  def check_completed_on_text
    if @completed_on_text.present? && Time.zone.parse(@completed_on_text).nil?
      errors.add @completed_on_text, "cannot be parsed"
    end
  rescue ArgumentError
    errors.add @completed_on_text, "is out of range"
  end

  def started_on_text
    @started_on_text || started_on.try(:strftime, "%Y-%m-%d %H:%M:%S")

  end

  def save_started_on_text
    self.started_on = Time.zone.parse(@started_on_text) if @started_on_text.present?
  end

  def check_started_on_text
    if @started_on_text.present? && Time.zone.parse(@started_on_text).nil?
      errors.add @started_on_text, "cannot be parsed"
    end
  rescue ArgumentError
    errors.add @started_on_text, "is out of range"
  end

  def create_customer
    self.customer = self.organization.customers.create(name: new_customer) if new_customer.present?
  end

end

