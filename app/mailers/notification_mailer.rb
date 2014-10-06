class NotificationMailer < ActionMailer::Base
  default from: "\"SubConTraX Alerts\" <notifications@subcontrax.com>"

  add_template_helper(ApplicationHelper)

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.sign_up_alert.subject
  #
                                                                                                # todo make more effiecient - in production does not load second level subclasses
  Dir.glob("#{Rails.root}/app/notifications/*.rb").sort.each { |file| require_dependency file } #if Rails.env == "development"
  ServiceCallNotification.subclasses.each do |subclass|
    define_method subclass.name.underscore do |subject, user, service_call, event|
      @service_call = service_call
      @user         = user
      @event        = event

      mail to: user.email, subject: subject
    end
  end

  AgreementNotification.subclasses.each do |subclass|
    define_method subclass.name.underscore do |subject, user, agreement, event|
      @agreement = agreement
      @user      = user
      @event     = event

      mail to: user.email, subject: subject
    end
  end

  InviteNotification.subclasses.each do |subclass|
    define_method subclass.name.underscore do |subject, user, invite, event|
      @invite = invite
      @user   = user
      @event  = event

      mail to: user.email, subject: subject, from: affiliate_from
    end
  end

  AdjustmentEntryNotification.subclasses.each do |subclass|
    define_method subclass.name.underscore do |subject, user, entry, event|
      @entry = event.entry
      @user  = user
      @event = event

      mail to: user.email, subject: subject
    end
  end

  #def agr_new_subcon_notification(subject, user, agreement)
  #  @agreement = agreement
  #  @user      = user
  #  mail to: user.email, subject: subject
  #end


  # todo implement method_missing to make the mailer more DRY
  #def method_missing(method, *args, &block)
  #
  #end

  private

  def affiliate_from

    if @invite.organization.email.present?
      "\"#{@invite.organization.name}\" <#{@invite.organization.email}>"
    else
      "\"#{@invite.organization.name} via SubConTraX\" <notifications@subcontrax.com>"
    end

  end
end
