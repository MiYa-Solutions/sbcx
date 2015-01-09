class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.where(invoiceable_id: invoice_params[:invoiceable_id], invoiceable_type: invoice_params[:invoiceable_type])

    respond_to do |format|
      format.html # index.html.erb
      format.mobile {
        @invoiceable = find_invoiceable
        @account = find_account
      } # index.mobile.erb
      format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    respond_to do |format|
      format.html
      format.xls


      format.json { render json: @invoice }
      #format.pdf do
      #  send_data @invoice.generate_pdf(view_context),
      #            filename:    "invoice_#{@invoice.id}.pdf",
      #            type:        "application/pdf",
      #            disposition: "inline"
      #end


      format.pdf {
        partial = params[:template].present? ? params[:template] : 'show'
        render pdf:                    "invoice_#{@invoice.id}",
               layout:                 'receipts',
               template:               "invoices/#{partial}.pdf",
               footer:                 { html: { template: 'layouts/_footer.pdf.erb' } },
               header:                 { html: { template: 'layouts/_header.pdf.erb' } },
               disable_internal_links: false }


    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    # @orig_invoicable -  in case the subcon issuing the invoice, the created invoice should be associated with the contractor ticket,
    # so @orig_invoiceable holds the subcon ticket used for the redirection
    respond_to do |format|
      if @invoice.save
        format.any(:html, :mobile) {
          redirect_to @orig_invoiceable, notice: 'Invoice was successfully created.'
        }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        flash[:error] = "Failed to create the invoice. #{humanized_errors}".html_safe
        format.html { redirect_to @orig_invoiceable }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def new_invoice_from_params
    @invoiceable          = find_invoiceable
    @invoice              = @invoiceable.invoices.build(invoice_params.except(:accountable_id, :accountable_type))
    @invoice.organization = @invoice.invoiceable.organization
    @invoice.account      = find_account
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def invoice_params
    params.require(:invoice).permit(:invoiceable_id,
                                    :invoiceable_type,
                                    :accountable_id,
                                    :accountable_type,
                                    :adv_payment_amount,
                                    :adv_payment_desc,
                                    :email_customer,
                                    :template,
                                    :notes)
  end


  def find_invoiceable
    invoiceable       = invoice_params[:invoiceable_type].classify.constantize.find(invoice_params[:invoiceable_id])
    @orig_invoiceable = invoiceable
    # in case the subcon issuing the invoice, it should be associated with the provider ticket
    if invoiceable.kind_of?(TransferredServiceCall)
      invoiceable = invoiceable.contractor_ticket
    end

    invoiceable
  end

  def find_account
    Account.where(organization_id: current_user.organization_id, accountable_id: invoice_params[:accountable_id], accountable_type: invoice_params[:accountable_type]).first
  end

  def humanized_errors
    res = '<br>'
    @invoice.errors.messages.each do |key, val|
      res = res + Invoice.human_attribute_name(key) + ': ' + val.join(', ') + '<br>'
    end
    res.html_safe
  end
end
