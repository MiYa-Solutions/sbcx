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
  attr_accessible :customer_id, :notes, :started_on, :completed_on
  belongs_to :customer, :inverse_of => :service_calls
  belongs_to :organization, :inverse_of => :service_calls
  belongs_to :subcontractor


  # State machine  for ServiceCall status

  # first we will define the service call state values
  STATUS_NEW         = 0
  STATUS_TRANSFERRED = 1
  STATUS_DISPATCHED  = 2
  STATUS_COMPLETED   = 3
  STATUS_SETTLED     = 4

  # The state machine definitions
  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW
    state :transferred, value: STATUS_TRANSFERRED
    state :dispatched, value: STATUS_DISPATCHED
    state :completed, value: STATUS_COMPLETED
    state :settled, value: STATUS_SETTLED

    before_transition :new => :transferred, :do => :transfer_service_call
    after_transition :new => :local_enabled, :do => :alert_local

    event :transfer do
      transition :new => :transferred
    end

    event :dispatch do
      transition [:new, :transferred] => :dispatched
    end

    event :complete do
      transition :dispatched => :completed
    end

    event :settle do
      transition :completed => :settled
    end

    def transfer(recipient, *args)
      Rails.logger.debug "Transferring job to #{recipient.name}"
      super
    end

  end

  def transfer_service_call(transition)
    recipient          = transition.args[0][:recipient]
    self.subcontractor = recipient
    Rails.logger.debug "Transferred Service Call to: #{recipient.name}"

  end

end
