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

    mail to: ENV["NEW_MEMBER_EVENT_EMAILS"], subject: "#{ENV["APP_NAME"]}: We have a new member!!!"
  end

  def new_message(message)
    @message = message
    mail to: ENV["NEW_MEMBER_EVENT_EMAILS"], subject: "#{ENV["APP_NAME"]}: New Message From a Web Visitor"
  end
end
