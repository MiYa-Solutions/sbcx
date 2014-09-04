class Forms::NotificationsForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  def initialize(setting)
    @setting = setting
    setup_user_settings
  end

  Setting.notification_settings.each do |s|
    attr_accessor s.to_sym
  end

  private

  def setup_user_settings
    @setting.notifications.each do |notification|
      if defined?("#{notification}=")
        send("#{notification}=", '1')
      end

    end
  end
end