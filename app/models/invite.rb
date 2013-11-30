class Invite < ActiveRecord::Base

  ##
  # Associations
  ##
  belongs_to :organization
  belongs_to :affiliate, class_name: 'Organization'
  has_many :events, as: :eventable, :order => 'id DESC'
  has_many :notifications, as: :notifiable, :order => 'id DESC'

  ##
  # Validations
  ##

  validates_presence_of :organization, :affiliate, :status

  ##
  # Callbacks
  ##

  after_create :invite_affiliate

  ##
  # State Machines
  ##
  STATUS_PENDING  = 0
  STATUS_ACCEPTED = 1
  STATUS_DECLINED = 2

  state_machine :status, initial: :pending do
    state :pending, value: STATUS_PENDING
    state :accepted, value: STATUS_ACCEPTED
    state :declined, value: STATUS_DECLINED

    after_transition any => :rejected do |invite|
      invite.events << InviteDeclinedEvent.new
    end

    after_transition any => :accepted do |invite|
      invite.events << InviteAcceptedEvent.new
    end

    event :accept do
      transition :pending => :accepted
    end

    event :decline do
      transition :pending => :rejected
    end
  end

  private

  def invite_affiliate
    events << NewInviteEvent.new
  end

end
