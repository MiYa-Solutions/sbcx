module InvoiceableTicket
  extend ActiveSupport::Concern
  include Invoiceable

  included do
    has_many :invoices, as: :invoiceable

    def invoiceable_items
      if work_done?
        get_items_for_final_invoice
      else
        get_items_for_active_invoice
      end

    end

    def invoice_total
      if work_done?
        invoiceable_items.collect { |item| item.amount }.sum + tax_amount
      else
        invoiceable_items.collect { |item| item.amount }.sum
      end
    end

    private
    def get_items_for_final_invoice
      boms + payments + customer_entries_for_final_invoice
    end

    def get_items_for_active_invoice
      payments + customer_entries_for_active_invoice
    end

    def customer_entries_for_final_invoice
      customer_entries.where(type: [RejectedPayment.name,MyAdjEntry.name, ReceivedAdjEntry.name, CustomerReimbursement.name] ).order('id ASC')
    end

    def customer_entries_for_active_invoice
      customer_entries.where(type: ['RejectedPayment', 'AdvancePayment']).order('id ASC')
    end
  end

end