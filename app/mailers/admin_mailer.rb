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

    mail to: Sbcx.config.new_member_event_emails, subject: "#{Rails.env}: We have a new member!!!"
  end
end
