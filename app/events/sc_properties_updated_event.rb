class ScPropertiesUpdatedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_properties_updated_event.name')
    self.description  = I18n.t('service_call_properties_updated_event.description', updating_org: self.properties[:updating_org])
    self.reference_id = 100043
  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
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
    attrs            = triggering_event.properties[:changed_attr]
    self.description += attr

    attrs.each do |key, value|
      service_call.send("#{key}=", value[1])
    end

    service_call.save!
    self.save!
  end

  private

  # define hstore properties methods
  %w[changed_attr updating_org].each do |key|
    scope "has_#{key}", lambda { |org_id, value| colleagues(org_id).where("properties @> (? => ?)", key, value) }

    define_method(key) do
      properties && properties[key]
    end

    define_method("#{key}=") do |value|
      self.properties = (properties || {}).merge(key => value)
    end
  end


end
