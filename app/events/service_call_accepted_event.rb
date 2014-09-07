class ServiceCallAcceptedEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_accepted_event.name')
    self.reference_id = 100002
    self.description  = I18n.t('service_call_accepted_event.description', subcon_name: service_call.subcontractor.name)

  end

  def notification_class
    ScAcceptedNotification
  end

  def update_provider
    prov_service_call.events << ServiceCallAcceptedEvent.new unless prov_service_call.events.pluck(:type).include? "ServiceCallAcceptedEvent"
  end

  def process_event
    # it is assumed that if the subcontractor is a member this event is generated as a result of that member accepting the service call
    # if the subcontractor is not a member, therefore it is assumed this event is triggered by the provider on behalf of a local
    # subcontractor and therefore there is no need to trigger the event again
    service_call.accept_work if service_call.subcontractor.subcontrax_member?
    super
  end


end