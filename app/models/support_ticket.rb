class SupportTicket < ActiveRecord::Base
  stampable
  acts_as_commentable
  has_many :comments, as: :commentable
  belongs_to :organization
  belongs_to :user, foreign_key: :creator_id

  validates_presence_of :organization, :subject, :description
  STATUS_NEW    = 0000
  STATUS_OPEN   = 0001
  STATUS_CLOSED = 0003

  state_machine :status, initial: :new do
    state :new, value: STATUS_NEW
    state :open, value: STATUS_OPEN
    state :closed, value: STATUS_CLOSED
  end


  scope :the_new, -> { where(status: STATUS_NEW) }
  scope :the_open, -> { where(status: STATUS_OPEN) }
  scope :the_closed, -> { where(status: STATUS_CLOSED) }

  after_create :notify_sbcx_support

  private
  def notify_sbcx_support
    AdminMailer.new_support_ticket(self).deliver
  end
end
