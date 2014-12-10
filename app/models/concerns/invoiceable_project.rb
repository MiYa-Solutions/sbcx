module InvoiceableProject
  extend ActiveSupport::Concern
  include Invoiceable

  included do
    def invoiceable_items(account = customer.account)
      tickets.collect { |t| t.invoiceable_items(account)}.flatten
    end

    def invoice_total(account = customer.account)
      tickets.collect { |t| t.invoice_total(account)}.sum(Money.new(0))
    end

    def tax_amount
      tickets.collect { |t| t.tax_amount}.sum(Money.new(0))
    end

    def tax
      tax_amount / invoice_total
    end
  end

end