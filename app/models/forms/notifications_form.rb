class Forms::NotificationsForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  Settings.job_notification_settings.each do |s|
    attr_accessor s.to_sym
    attr_accessor "#{s}_email".to_sym
  end

  Settings.adj_notification_settings.each do |s|
    attr_accessor s.to_sym
    attr_accessor "#{s}_email".to_sym
  end

  Settings.invite_notification_settings.each do |s|
    attr_accessor s.to_sym
    attr_accessor "#{s}_email".to_sym
  end

  Settings.agr_notification_settings.each do |s|
    attr_accessor s.to_sym
    attr_accessor "#{s}_email".to_sym
  end

  Settings.aff_payments_settings.each do |s|
    attr_accessor s.to_sym
    attr_accessor "#{s}_email".to_sym
  end

  def persisted?
    false
  end

  def initialize(setting)
    @settings = setting
    setup_user_settings
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