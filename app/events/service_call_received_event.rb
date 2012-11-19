class ServiceCallReceivedEvent < Event
  def init
    self.name         = I18n.t('service_call_received_event.name')
    self.reference_id = 11
  end

  def process_event
    service_call = associated_object
    org          = service_call.organization

    User.my_admins(org.id).each do |user|
      service_call.notifications << ReceivedServiceCallNotification.new(subject: "You Received New Service Call", content: "This content ", user: user)
    end

  end

end