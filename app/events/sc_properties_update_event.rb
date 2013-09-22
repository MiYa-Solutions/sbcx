class ScPropertiesUpdateEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_properties_update_event.name')
    self.description  = I18n.t('service_call_properties_update_event.description', user: creator.name)
    self.reference_id = 100042
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    e                           = ScPropertiesUpdatedEvent.new(triggering_event: self)
    e.properties[:updating_org] = creator.organization.name
    prov_service_call.events << e
  end

  def update_subcontractor
    subcon_service_call.events << ScPropertiesUpdatedEvent.new(triggering_event: self)
  end

  def process_event

    #properties.each do |attr|
    #  description += "\nattribute: #{attr} old value: #{properties[attr][0]}, updated value: #{properties[attr][1]}"
    #end
    self.description.concat "\n#{self.properties['changed_attrs']}"
    self.save

    super

  end

end

