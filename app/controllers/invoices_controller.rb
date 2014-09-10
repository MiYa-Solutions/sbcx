class InvoicesController < ApplicationController

  filter_resource_access

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.where(ticket_id: invoice_params[:ticket_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])

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
      format.pdf { render pdf: "invoice_#{@invoice.id}",
                          layout: 'receipts',
                          footer:                 { html: { template: 'layouts/_footer.pdf.erb' } },
                          header:                 { html: { template: 'layouts/_header.pdf.erb' } },
                          disable_internal_links: false }


    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.json
  def create

    respond_to do |format|
      if @invoice.save
        format.any(:html, :mobile) { redirect_to @invoice.ticket, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        flash[:error] = "Failed to create the invoice. #{humanized_errors}".html_safe
        format.html { redirect_to @invoice.ticket }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  protected

  def new_invoice_from_params
    @invoice              = Invoice.new(invoice_params)
    @invoice.organization = @invoice.ticket.organization
    @invoice.account      = @invoice.ticket.customer.account
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def invoice_params
    params.require(:invoice).permit!
  end

  def humanized_errors
    res = '<br>'
    @invoice.errors.messages.each do |key, val|
      res = res + Invoice.human_attribute_name(key) + ': ' + val.join(', ') + '<br>'
    end
    res.html_safe
  end
end
