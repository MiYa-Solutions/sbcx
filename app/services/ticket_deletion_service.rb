class TicketDeletionService

  def initialize(ticket)
    @ticket = ticket
  end

  def execute
    Event.transaction do
      org.events << deletion_event
      @ticket.destroy
    end
  end

  private

  def deletion_event
    @del_event ||= TicketDeletionEvent.new(ticket: @ticket)
  end

  def org
    @org ||= @ticket.organization
  end
end