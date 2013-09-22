class TicketSynchService

  def after_save(ticket)
    event            = ScPropertiesUpdateEvent.new
    event.properties = (event.properties || {}).merge({ changed_attrs: ticket.changes })
    ticket.events << event
  end
end