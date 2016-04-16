class CustomerNotification < Notification

  def deliver(customer)
    mailer_method = self.class.name.underscore #.sub("_notification", "")
    CustomerMailer.send(mailer_method, default_subject, customer, notifiable).deliver
  end

end
