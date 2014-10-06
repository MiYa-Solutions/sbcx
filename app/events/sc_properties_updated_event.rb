class ScPropertiesUpdatedEvent < ScPropSynchEvent

  def init
    self.name = I18n.t('service_call_properties_updated_event.name')
    self.description = I18n.t('service_call_properties_updated_event.description', updating_org: triggering_event.user.organization.name) unless self.description
    self.reference_id = 100043
  end

  def notification_class
    ScPropsUpdatedNotification
  end

  def update_provider
    prov_service_call.events << ScPropertiesUpdatedEvent.new(triggering_event: self) unless triggering_event.service_call == prov_service_call
  end

  def update_subcontractor
    subcon_service_call.events << ScPropertiesUpdatedEvent.new(triggering_event: self) unless triggering_event.service_call == subcon_service_call
  end

  def process_event
    self.properties = triggering_event.properties
    synch_ticket
    super
  end


end
