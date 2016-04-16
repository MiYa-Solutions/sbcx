require 'hstore_setup_methods'

class TicketDeletionEvent < Event
  extend HstoreSetupMethods

  setup_hstore_attr 'ticket_id'
  has_one :ticket

  def init
    self.name         = I18n.t('ticket_deletion_event.name')
    self.reference_id = 5
  end

  # this is the event processed by the observer after the creation
  def process_event
    Rails.logger.debug { "Processing ticket deletion event" }
    self.description = I18n.t('ticket_deletion_event.description', ref: ticket.ref_id, data: ticket_data)
    self.save!
  end

  private

  def ticket_data
    res = ''
    res = res + ticket.to_json + '== BOMS =='
    res = res + ticket.boms.to_json
    res
  end

  # def ticket
  #   @ticket ||= Ticket.find(ticket_id)
  # end

end
