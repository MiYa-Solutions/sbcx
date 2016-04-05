require 'hstore_setup_methods'
class ScInvoiceEvent < Event
  extend HstoreSetupMethods

  setup_hstore_attr 'notify_customer?'
  setup_hstore_attr 'invoice_id'
  belongs_to :invoice

  def init
    self.name         = I18n.t('service_call_invoice_event.name')
    self.description  = I18n.t('service_call_invoice_event.description')
    self.reference_id = 100018
  end

  def process_event
    unless notify_customer? == '0' || notify_customer?.blank? || notify_customer? == 'false'
      ScInvoiceNotification.new(notifiable: invoice, event: self).deliver(invoice.ticket.customer)
    end
  end
end