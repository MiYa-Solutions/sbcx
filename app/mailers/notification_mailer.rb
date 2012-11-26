class NotificationMailer < ActionMailer::Base
  default from: "info@subcontrax.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.sign_up_alert.subject
  #
  def received_new_service_call(user, service_call)
    @service_call = service_call
    @user         = user

    mail to: user.email, subject: I18n.t('notification_mailer.received_new_service_call.subject', provider: service_call.provider.name)
  end

  def completed_new_service_call(user, service_call)
    @service_call = service_call
    @user         = user
    if service_call.technician.id == user.organization.technicians
      subject =
          I18n.t('notification_mailer.completed_service_call.subject', provider: service_call.provider.name)
    else
      subject =
          I18n.t('notification_mailer.completed.subject', technician: service_call.provider.name)
    end

    mail to: user.email, subject: subject

  end

end
