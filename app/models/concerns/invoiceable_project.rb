module InvoiceableProject
  extend ActiveSupport::Concern
  include Invoiceable

  included do
    def invoiceable_items
      tickets.collect { |t| t.invoiceable_items}.flatten
    end

    def invoice_total
      tickets.collect { |t| t.invoice_total}.sum(Money.new(0))
    end
  end

end