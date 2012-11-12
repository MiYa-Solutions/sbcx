# == Schema Information
#
# Table name: agreements
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  subcontractor_id :integer
#  provider_id      :integer
#  description      :text
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Agreement < ActiveRecord::Base

  #attr_accessible :provider_id, :subcontractor_id, :provider, :subcontractor

  belongs_to :provider, class_name: "Provider"
  belongs_to :subcontractor, class_name: "Subcontractor"

  validates :provider, presence: true
  validates :subcontractor, presence: true

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
    state :disabled, value: STATUS_SBCX_INACTIVE_MEMBER


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
