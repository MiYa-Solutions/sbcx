class Notification < ActiveRecord::Base
  #include ActionView::Helpers
  include ActionView::Helpers::UrlHelper

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  NOTIFICATION_UNREAD = 0
  NOTIFICATION_READ   = 1


  state_machine :status, :initial => :unread do
    state :unread, value: NOTIFICATION_UNREAD
    state :read, value: NOTIFICATION_READ

    event :read do
      transition :unread => :read
    end

  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

end
