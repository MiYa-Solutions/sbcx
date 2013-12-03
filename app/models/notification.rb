# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  subject         :string(255)
#  content         :text
#  status          :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :integer
#  notifiable_type :string(255)
#  type            :string(255)
#

class Notification < ActiveRecord::Base
  #include ActionView::Helpers
  include ActionView::Helpers::UrlHelper

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  NOTIFICATION_UNREAD = 0
  NOTIFICATION_READ   = 1

  before_validation :set_default_subject, :set_default_content

  validates_presence_of :user, :subject, :content, :status


  state_machine :status, :initial => :unread do
    state :unread, value: NOTIFICATION_UNREAD
    state :read, value: NOTIFICATION_READ

    event :read do
      transition :unread => :read
    end

  end

  scope :my_notifications, ->(user_id) { where(:user_id => user_id) }

  def url_helpers
    Rails.application.routes.url_helpers
  end

  # this method assumes that the NotificationMailer has a method by the name of the notification class
  def deliver
    mailer_method = self.class.name.underscore #.sub("_notification", "")
    NotificationMailer.send(mailer_method, default_subject, user, notifiable).deliver
  end

  protected

  def default_subject
    raise NotImplementedError.new "You probably forgot to implement the default_subject method in #{self.class.name}"
  end

  def default_content
    raise NotImplementedError.new "You probably forgot to implement the default_content method in #{self.class.name}"
  end

  private

  # default subject is expected to be implemented by the subclass
  def set_default_subject
    self.subject = self.default_subject
  end

  def set_default_content
    self.content = self.default_content
  end


end
