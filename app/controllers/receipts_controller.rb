class ReceiptsController < ApplicationController
  filter_resource_access context: :accounting_entries
  def show

    respond_to do |format|
      format.html {}
      format.pdf do
        render pdf:                    "receipt_#{@receipt.id}",
               layout:                 'receipts',
               disable_internal_links: false,
               footer:                 { html: { template: 'layouts/_footer.pdf.erb' } },
               header:                 { html: { template: 'layouts/_header.pdf.erb' } }
      end
    end

  end

  def load_receipt
    @receipt = AccountingEntry.find(params[:id])
  end
end
