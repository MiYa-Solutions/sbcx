class AdminMailer < ActionMailer::Base
  default from: "admin@subcontrax.com"
  default reply_to: "admin@subcontrax.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.sign_up_alert.subject
  #
  def sign_up_alert(org)
    @organization = org

    mail to: ENV["NEW_MEMBER_EVENT_EMAILS"], subject: "#{Rails.env}: We have a new member!!!"
  end
end
