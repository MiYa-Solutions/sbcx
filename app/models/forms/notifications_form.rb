class Forms::NotificationsForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  def initialize(setting)
    @settings = setting
    setup_user_settings
  end

  Settings.notification_settings.each do |s|
    attr_accessor s.to_sym
    attr_accessor "#{s}_email".to_sym
  end

  private

  def setup_user_settings
    @settings.notifications.each do |notification|
      if defined?("#{notification}=")
        send("#{notification}=", 'true')
      end
    end

    @settings.notification_emails.each do |notif_email|
      if defined?("#{notif_email}=")
        send("#{notif_email}=", 'true')
      end
    end
  end
end