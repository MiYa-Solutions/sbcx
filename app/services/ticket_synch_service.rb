class TicketSynchService

  def before_update(ticket)
    @ticket        = ticket
    @changed_attrs = @ticket.changes
    clean_attributes
    unless (@changed_attrs.keys & ScPropSynchEvent.ticket_attributes).empty?
      @event = ScPropertiesUpdateEvent.new
      create_props
      ticket.events << @event
    end
    true
  end


  private

  # remove the attributes that are being updated as part of a state machine event
  def clean_attributes
    @changed_attrs.delete('started_on') if @changed_attrs['work_status'] && @changed_attrs['work_status'][1] == ServiceCall::WORK_STATUS_IN_PROGRESS
    @changed_attrs.delete('completed_on') if @changed_attrs['work_status'] && @changed_attrs['work_status'][1] == ServiceCall::WORK_STATUS_DONE
  end

  def create_props
    @event.properties = {}

    ScPropSynchEvent.ticket_attributes.each do |attr|
      if @changed_attrs[attr]
        @event.properties = @event.properties.merge({ attr => @changed_attrs[attr][1] }).merge({ "#{attr}_old" => @changed_attrs[attr][0] })
      end
    end
  end

end