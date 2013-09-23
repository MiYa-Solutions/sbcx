class ScPropSynchEvent < ServiceCallEvent

  def self.ticket_string_attributes
    %w[company address1 address2 city state zip country phone mobile_phone work_phone email]
  end

  def self.ticket_date_attributes
    %w[started_on completed_on scheduled_for]
  end

  def self.ticket_attributes
    self.ticket_string_attributes + self.ticket_date_attributes
  end

  # define hstore properties methods
  ticket_string_attributes.each do |key|
    scope "has_#{key}", lambda { |org_id, value| colleagues(org_id).where("properties @> (? => ?)", key, value) }

    define_method(key) do
      properties && properties[key]
    end

    define_method("#{key}=") do |value|
      self.properties = (properties || {}).merge(key => value)
    end
  end

  ticket_date_attributes.each do |key|
    scope "has_#{key}", ->(org_id, value) { colleagues(org_id).where("properties @> (? => ?)", key, value) }

    define_method(key) do
      Time.zone.parse(properties[key]) if properties && properties[key]
    end

    define_method("#{key}=") do |value|
      self.properties = (properties || {}).merge(key => value)
    end
  end

  def synch_ticket
    ScPropSynchEvent.ticket_attributes.each do |attr|
      service_call.update_column attr, self.send(attr) if properties[attr]
    end
    set_description
    service_call.save!
  end

  def set_description
    ScPropSynchEvent.ticket_attributes.each do |attr|
      #self.description += "\n* #{service_call.class.human_attribute_name(attr)} - new value: #{self.properties[attr]}, old value: #{self.properties["#{attr}_old"]}" if self.properties[attr]
      self.description += "\n* #{I18n.t('service_call_prop_synch_event.description', attr_name: service_call.class.human_attribute_name(attr), new_val: properties[attr], old_val: self.properties["#{attr}_old"])}" if self.properties[attr]
      self.description = self.description.truncate(255)
    end

    self.save!
  end


end
