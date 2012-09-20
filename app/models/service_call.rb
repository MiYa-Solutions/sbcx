# == Schema Information
#
# Table name: service_calls
#
#  id               :integer         not null, primary key
#  customer_id      :integer
#  notes            :text
#  started_on       :datetime
#  organization_id  :integer
#  completed_on     :datetime
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  status           :integer
#  subcontractor_id :integer
#

class ServiceCall < ActiveRecord::Base
  attr_accessible :customer_id, :notes, :started_on, :completed_on, :completed_on_text, :started_on_text, :new_customer
  belongs_to :customer, :inverse_of => :service_calls
  belongs_to :organization, :inverse_of => :service_calls
  belongs_to :subcontractor

  # virtual attributes
  attr_writer :started_on_text
  attr_writer :completed_on_text
  attr_accessor :new_customer

  before_save :save_started_on_text
  before_save :save_completed_on_text
  before_save :create_customer

  validate :check_completed_on_text, :check_started_on_text

  accepts_nested_attributes_for :customer


  # State machine  for ServiceCall status

  # first we will define the service call state values
  STATUS_NEW         = 0
  STATUS_OPEN        = 1
  STATUS_CLOSED      = 2
  STATUS_DISPATCHED  = 3
  STATUS_IN_PROGRESS = 4
  STATUS_WORK_DONE   = 5


  # The state machine definitions
  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW
    state :open, value: STATUS_OPEN
    state :closed, value: STATUS_CLOSED
    state :dispatched, value: STATUS_DISPATCHED
    state :in_progress, value: STATUS_IN_PROGRESS
    state :work_done, value: STATUS_WORK_DONE

    #before_transition :new => :transferred, :do => :transfer_service_call
    #after_transition :new => :local_enabled, :do => :alert_local

    event :transfer do
      transition :new => :open
    end

    event :close do
      transition :open => :closed
    end

    event :dispatch do
      transition :new => :dispatched
    end

    event :start do
      transition :dispatched => :in_progress
    end

    event :settle do
      transition :work_done => :closed
    end

    event :settle do
      transition :work_done => :closed
    end

    #def transfer(recipient, *args)
    #  Rails.logger.debug "Transferring job to #{recipient.name}"
    #  super
    #end

  end

  def transfer_service_call(transition)
    recipient          = transition.args[0][:recipient]
    self.subcontractor = recipient
    Rails.logger.debug "Transferred Service Call to: #{recipient.name}"

  end

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
