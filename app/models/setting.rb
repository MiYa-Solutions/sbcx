class Setting
  include ActiveModel::Validations

  def self.notification_settings
    ServiceCallNotification.subclasses.collect { |c| c.name.underscore }
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
    @user.preferences.select { |key, val| (val == '1' || val == 'true') }.keys & Setting.notification_settings
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