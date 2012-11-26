class ServiceCallReceivedEvent < Event
  def init
    self.name         = I18n.t('service_call_received_event.name')
    self.reference_id = 11
  end

  def process_event
    service_call = associated_object
    org          = service_call.organization

    User.my_admins(org.id).each do |user|
      notification = ReceivedServiceCallNotification.new(subject: I18n.t('notification_mailer.received_new_service_call.subject', provider: service_call.provider.name), user: user)
      service_call.notifications << notification
      notification.deliver
    end

  end

end