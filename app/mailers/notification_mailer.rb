class NotificationMailer < ActionMailer::Base
  default from: "notifications@subcontrax.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.sign_up_alert.subject
  #
  # todo make more effiecient - in production does not load second level subclasses
  Dir.glob("#{Rails.root}/app/notifications/*.rb").sort.each { |file| require_dependency file } #if Rails.env == "development"
  ServiceCallNotification.subclasses.each do |subclass|
    define_method subclass.name.underscore do |subject, user, service_call|
      @service_call = service_call
      @user         = user

      mail to: user.email, subject: subject
    end
  end

  def agr_new_subcon_notification(subject, user, agreement)
    @agreement = agreement
    @user      = user
    mail to: user.email, subject: subject
  end


  # todo implement method_missing to make the mailer more DRY
  #def method_missing(method, *args, &block)
  #
  #end
end
