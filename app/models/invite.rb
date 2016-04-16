# == Schema Information
#
# Table name: invites
#
#  id              :integer          not null, primary key
#  message         :string(255)
#  organization_id :integer
#  affiliate_id    :integer
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :integer
#  updater_id      :integer
#

class Invite < ActiveRecord::Base

  stampable

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

    after_transition any => :declined do |invite|
      invite.events << InviteDeclinedEvent.new
    end

    after_transition any => :accepted do |invite|
      invite.events << InviteAcceptedEvent.new
    end

    event :accept do
      transition :pending => :accepted
    end

    event :decline do
      transition :pending => :declined
    end
  end

  private

  def invite_affiliate
    events << NewInviteEvent.new
  end

end
