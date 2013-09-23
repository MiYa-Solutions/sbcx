class ScPropertiesUpdateEvent < ScPropSynchEvent

  def init
    self.name = I18n.t('service_call_properties_update_event.name')
    self.description = I18n.t('service_call_properties_update_event.description', user: creator.name) unless self.description
    self.reference_id = 100042
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    e = ScPropertiesUpdatedEvent.new(triggering_event: self)
    prov_service_call.events << e
  end

  def update_subcontractor
    subcon_service_call.events << ScPropertiesUpdatedEvent.new(triggering_event: self)
  end

  def process_event


    set_description

    self.save!

    super

  end

end

