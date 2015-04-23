module InvoiceableTicket
  extend ActiveSupport::Concern
  include Invoiceable

  included do


    def invoiceable_items(account = customer.account)
      if customer.account == account
        if work_done?
          CustomerInvoiceItems.new(self).get_items_for_final_invoice
        else
          CustomerInvoiceItems.new(self).get_items_for_active_invoice
        end
      else
        AccountingEntry.none
      end

    end

    def invoice_total(account = customer.account)
      if work_done?
        invoiceable_items(account).collect { |item| item.amount }.sum(Money.new(0)) + tax_amount
      else
        invoiceable_items(account).collect { |item| item.amount }.sum(Money.new(0))
      end
    end

    private

    class CustomerInvoiceItems
      def initialize(invoiceable)
        @invoiceable = invoiceable
      end

      def get_items_for_final_invoice
        @invoiceable.boms + @invoiceable.payments + entries_for_final_invoice
      end

      def get_items_for_active_invoice
        @invoiceable.payments + entries_for_active_invoice
      end

      private

      def entries_for_final_invoice
        res = @invoiceable.customer_entries.where(type: [RejectedPayment.name, CustomerReimbursement.name]).order('id ASC')
        @invoiceable.customer_entries.where(type: [MyAdjEntry.name, ReceivedAdjEntry.name]).order('id ASC').each do |e|
          res << e
          res << e.matching_entry if e.matching_entry
        end
        res
      end

      def entries_for_active_invoice
        @invoiceable.customer_entries.where(type: ['RejectedPayment', 'AdvancePayment']).order('id ASC')
      end
    end
  end

end