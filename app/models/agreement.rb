# == Schema Information
#
# Table name: agreements
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#

class Agreement < ActiveRecord::Base

  belongs_to :organization
  belongs_to :counterparty, polymorphic: true


  # State machine  for Organization status

  # first we will define the organization state values
  STATUS_NEW              = 0
  STATUS_PENDING_APPROVAL = 1
  STATUS_REJECTED         = 2
  STATUS_ACTIVE           = 3
  STATUS_DISABLED         = 4

  # The state machine definitions
  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW
    state :pending_approval, value: STATUS_PENDING_APPROVAL
    state :rejected, value: STATUS_REJECTED
    state :active, value: STATUS_ACTIVE
    state :disabled, value: STATUS_DISABLED


    event :submit do
      transition :new => :pending_approval
    end

    event :approve do
      transition [:pending_approval, :new] => :active
    end


    event :reject do
      transition :pending_approval => :rejected
    end

    event :disable do
      transition [:new, :active, :pending_approval, :rejected] => :disabled
    end

    event :enable do
      transition :disabled => :new

    end


  end

end
