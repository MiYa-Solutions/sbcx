class Settings
  include ActiveModel::Validations

  def self.job_notification_settings
    ServiceCallNotification.subclasses.collect { |c| c.name.underscore }
  end

  def self.adj_notification_settings
    AdjustmentEntryNotification.subclasses.collect { |c| c.name.underscore }
  end

  def self.invite_notification_settings
    InviteNotification.subclasses.select { |c| c != SbcxReferenceNotification }.collect { |c| c.name.underscore }
  end

  def self.mandatory_emails
    InviteNotification.subclasses.select { |c| c != SbcxReferenceNotification }.collect { |c| "#{c.name.underscore}_email" }
  end


  def initialize(user)
    @user = user
  end

  def notifications_form
    @notifications_form ||= Forms::NotificationsForm.new(self)
  end


  def save(params)
    if params.nil?
      self.errors.add :notifications, "Empty parameters"
      return false
    else
      save_user_settings(params)
    end
  end

  def notifications
    @user.preferences.select { |key, val| (val == '1' || val == 'true') }.keys & Settings.job_notification_settings
  end

  def notification_emails
    @user.preferences.select { |key, val| (val == '1' || val == 'true') }.keys & Settings.job_notification_settings.map { |n| "#{n}_email" }
  end

  def send_notification_email?(notif)
    Settings.mandatory_emails.include?("#{notif.class.name.underscore}_email") ||
        @user.preferences["#{notif.class.name.underscore}_email"] && @user.preferences["#{notif.class.name.underscore}_email"] == 'true'
  end

  private

  def save_user_settings(params)
    serialize_settings(params)
    @user.save
  end

  def serialize_settings(params)
    params.each do |key, value|
      @user.preferences = (@user.preferences || {}).merge(key => value)
    end

  end

end