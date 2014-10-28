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

  def new_support_ticket(support_ticket)
    @support_ticket = support_ticket
    mail to: ENV["NEW_MEMBER_EVENT_EMAILS"], subject: "#{ENV["APP_NAME"]}: New Support Ticket From #{@support_ticket.organization.name}"
  end

  def new_support_comment(comment)
    @comment = comment
    mail to: ENV["NEW_MEMBER_EVENT_EMAILS"], subject: "#{ENV["APP_NAME"]}: New Support Comment From #{@comment.commentable.organization.name}"
  end
end
