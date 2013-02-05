class NotificationMailer < ActionMailer::Base
  default from: "notifications@subcontrax.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.sign_up_alert.subject
  #
  def sc_received_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user

    mail to: user.email, subject: subject
  end

  def sc_completed_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_complete_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_accepted_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_cancel_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_canceled_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_dispatch_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_dispatched_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_paid_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_rejected_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_settle_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_invoiced_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_start_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_started_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
  end

  def sc_settled_notification(subject, user, service_call)
    @service_call = service_call
    @user         = user
    mail to: user.email, subject: subject
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
