class Invoice < ActiveRecord::Base
  include Forms::InvoiceForm

  belongs_to :organization
  belongs_to :ticket
  belongs_to :account
  has_many :notifications, as: :notifiable

  monetize :total_cents, allow_nil: true

  has_many :invoice_items, :source => :invoice
  has_many :bom_items, through: :invoice_items, :source => :bom, conditions: "invoice_items.invoiceable_type = 'Bom'"
  has_many :payment_items, through: :invoice_items, :source => :entry, conditions: "invoice_items.invoiceable_type in ('AmexPayment', 'CashPayment', 'ChequePayment','CreditPayment', 'RejectedPayment' )"
  has_many :adv_payment_items, through: :invoice_items, :source => :entry, conditions: "invoice_items.invoiceable_type in ('AdvancePayment')"
  has_many :charge_items, through: :invoice_items, :source => :entry, conditions: "invoice_items.invoiceable_type in ('ServiceCallCharge')"

  after_create :finalize

  validates_presence_of :organization, :ticket, :account

  def generate_pdf(view)
    InvoicePdf.new(self, view).render
  end

  private

  def finalize
    if ticket.work_done?
      generate_final_invoice
    else
      generate_active_invoice
    end

    self.save!

    ticket.events << ScInvoiceEvent.new(invoice: self, notify_customer?: email_customer)
  end

  def final_total
    Money.new(invoice_items.collect { |e| e.invoiceable.amount }.sum) + ticket.tax_amount
  end

  def active_total
    Money.new(invoice_items.collect { |e| e.invoiceable.amount }.sum)
  end


  def generate_final_invoice
    ticket.boms.each do |bom|
      item = InvoiceItem.new(invoiceable_id: bom.id, invoiceable_type: bom.class.name)
      self.invoice_items << item
    end

    ticket.payments.each do |payment|
      item = InvoiceItem.new(invoiceable_id: payment.id, invoiceable_type: payment.class.name)
      self.invoice_items << item
    end

    ticket.entries.where(type: 'RejectedPayment').each do |e|
      item = InvoiceItem.new(invoiceable_id: e.id, invoiceable_type: e.class.name)
      self.invoice_items << item
    end

    ticket.entries.where(type: 'MyAdjEntry').each do |e|
      item = InvoiceItem.new(invoiceable_id: e.id, invoiceable_type: e.class.name)
      self.invoice_items << item
    end

    self.total = final_total


  end

  def generate_active_invoice
    ticket.payments.each do |payment|
      item = InvoiceItem.new(invoiceable_id: payment.id, invoiceable_type: payment.class.name)
      self.invoice_items << item
    end

    ticket.entries.where(type: ['RejectedPayment', 'AdvancePayment']).each do |e|
      item = InvoiceItem.new(invoiceable_id: e.id, invoiceable_type: e.class.name)
      self.invoice_items << item
    end

    self.total = active_total
  end

  class InvoiceData
    def initialize(invoice)
      @invoice = invoice
    end

    def ticket
      @invoice.ticket
    end

    def company_logo
      'LogoImg.png'
    end

    def customer_name
      ticket.customer.name || ''
    end

    def customer_company
      ticket.customer.company || ''
    end

    def customer_address1
      ticket.customer.address1 || ''
    end

    def customer_address2
      ticket.customer.address2 || ''
    end

    def customer_city
      ticket.customer.city || ''
    end

    def customer_state
      ticket.customer.state || ''
    end

    def customer_phone
      ticket.customer.phone || ''
    end

    def customer_zip
      ticket.customer.zip || ''
    end

    def ticket_address
      "#{ticket.address1} #{ticket.address2}, #{ticket.city}, #{ticket.state} #{ticket.zip}"

    end

    def location_differanet_from_address?
      customer_address1 != ticket.address1
    end

    def number
      @invoice.id
    end

    def date
      @invoice.created_at
    end

    def total_before_tax
      @invoice.total - tax_amount
    end

    def total
      @invoice.total
    end

    def notes
      @invoice.notes
    end

    def tax
      ticket.tax || ''
    end

    def tax_amount
      ticket.tax_amount || Money.new(0)
    end

    def company_name
      job_owner.name || ''
    end

    def company_address1
      job_owner.address1 || ''
    end

    def company_address2
      job_owner.address2 || ''
    end

    def company_city_and_state
      "#{job_owner.city}, #{job_owner.state} #{job_owner.zip}"
    end

    def boms
      ticket.boms
    end

    def invoice_items
      @invoice.invoice_items
    end

    def job_owner
      member_job = MyServiceCall.find_by_ref_id ticket.ref_id
      if member_job.nil?
        res = TransferredServiceCall.where(ref_id: ticket.ref_id).order('id desc').first.provider
      else
        res = member_job.organization
      end
      res
    end


  end

  class InvoicePdf < Prawn::Document
    def initialize(invoice, view)
      super()
      @invoice          = InvoiceData.new(invoice)
      @view             = view
      @address_x        = 10
      @lineheight_y     = 12
      @invoice_header_x = 325
      create_the_invoice
    end

    attr_reader :address_x
    attr_reader :lineheight_y
    attr_reader :invoice_header_x


    def create_the_invoice
      move_down 5
      header
      move_down 50
      client_address
      invoice_summary
      items_table
      notes
      footer
    end

    private

    def header
      # Add the font style and size
      font "Helvetica"
      font_size 9

      text_box @invoice.company_name, :at => [address_x, cursor]
      move_down lineheight_y
      text_box @invoice.company_address1, :at => [address_x, cursor]
      move_down lineheight_y
      text_box @invoice.company_address2, :at => [address_x, cursor] unless @invoice.company_address2.blank?
      move_down lineheight_y unless @invoice.company_address2.blank?
      text_box @invoice.company_city_and_state, :at => [address_x, cursor]
      move_down lineheight_y

      last_measured_y = cursor
      move_cursor_to bounds.height

      #image logopath, :width => 215, :position => :right
      #text_box @invoice.org_name, :width => 215, :position => :right
      table([[@invoice.company_name]],
            :width      => 215,
            :position   => :right,
            :cell_style => { valign: :center, align: :center, size: 20, :font => "Times-Roman", :font_style => :bold }
      )

      move_cursor_to last_measured_y

    end

    def client_address


      last_measured_y = cursor

      text_box @invoice.customer_company, :at => [address_x, cursor]
      move_down lineheight_y
      text_box @invoice.customer_name, :at => [address_x, cursor] unless (@invoice.customer_name == @invoice.customer_company || @invoice.customer_name.blank?)
      move_down lineheight_y
      text_box @invoice.customer_address1, :at => [address_x, cursor]
      move_down lineheight_y
      text_box @invoice.customer_address2, :at => [address_x, cursor] unless @invoice.customer_address2.blank?
      move_down lineheight_y unless @invoice.customer_address2.blank?
      text_box "#{@invoice.customer_state}, #{@invoice.customer_city} #{@invoice.customer_zip}", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "Phone: #{@invoice.customer_phone}", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "Location: #{@invoice.ticket_address}", :at => [address_x, cursor] if @invoice.location_differanet_from_address?
      move_down lineheight_y if @invoice.location_differanet_from_address?

      move_cursor_to last_measured_y - (lineheight_y)

    end

    def invoice_summary
      invoice_header_data = [
          ["Invoice #", @invoice.number],
          ["Job #", @invoice.ticket.id],
          ["Invoice Date", @view.l(@invoice.date, format: :date_only)],
          ["Amount Due", @view.humanized_money_with_symbol(@invoice.total)]
      ]

      table(invoice_header_data, :position => invoice_header_x, :width => 215) do
        style(row(0..2).columns(0..1), :padding => [1, 5, 1, 5], :borders => [])
        style(row(3), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
        style(column(1), :align => :right)
        style(row(3).columns(0), :borders => [:top, :left, :bottom])
        style(row(3).columns(1), :borders => [:top, :right, :bottom])
      end

    end

    def items_table
      move_down 35

      table(invoice_items, :width => bounds.width) do
        style(row(1..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'dddddd')
        style(row(0), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
        style(row(0).columns(0..-1), :borders => [:top, :bottom])
        style(row(0).columns(0), :borders => [:top, :left, :bottom])
        style(row(0).columns(-1), :borders => [:top, :right, :bottom])
        style(row(-1), :border_width => 2)
        style(column(2..-1), :align => :right)
        style(columns(0), :width => 95)
        style(columns(1), :width => 255)
      end

      move_down 1

      invoice_services_totals_data = [
          ["Sub Total", @view.humanized_money_with_symbol(@invoice.total_before_tax)],
          ["Tax (#{@invoice.tax}%)", @view.humanized_money_with_symbol(@invoice.tax_amount)],
          ["Amount Due", @view.humanized_money_with_symbol(@invoice.total)]
      ]

      table(invoice_services_totals_data, :position => invoice_header_x, :width => 215) do
        style(row(0..1).columns(0..1), :padding => [1, 5, 1, 5], :borders => [])
        style(row(0), :font_style => :bold)
        style(row(2), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
        style(column(1), :align => :right)
        style(row(2).columns(0), :borders => [:top, :left, :bottom])
        style(row(2).columns(1), :borders => [:top, :right, :bottom])
      end

      move_down 25

    end

    def notes
      invoice_terms_data = [
          ["Terms"],
          ["Payable upon receipt"]
      ]

      table(invoice_terms_data, :width => 275) do
        style(row(0..-1).columns(0..-1), :padding => [1, 0, 1, 0], :borders => [])
        style(row(0).columns(0), :font_style => :bold)
      end

      move_down 15

      invoice_notes_data = [
          ["Notes"],
          [@invoice.notes],
          ["Thank you for doing business with #{@invoice.company_name}"]
      ]

      table(invoice_notes_data, :width => 275) do
        style(row(0..-1).columns(0..-1), :padding => [1, 0, 1, 0], :borders => [])
        style(row(0).columns(0), :font_style => :bold)
      end
    end

    def footer
      logopath = "#{Rails.root}/app/assets/images/LogoImg.png"
      #move_cursor_to 50

      repeat :all do
        bounding_box([bounds.left, bounds.bottom + 30], :height => 50, :width => bounds.right) do
          stroke_horizontal_rule
          move_down(2)
          text "Powered By ", valign: :left
          image logopath, height: 20
          #link_annotation([100, 100, 5, 5], :Border => [0,0,1], :A => { :Type => :Action, :S => :URI, :URI => Prawn::LiteralString.new("http://www.subcontrax.com") } )
          #text "<a href=''>www.subcontrax.com</a>"
          formatted_text [{ text: 'www.subcontrax.com', color: '0000FF', link: "http://www.subcontrax.com" }]
          #move_down 5
          #text_box "Page #{page_count}"
        end
      end
    end


    def invoice_items
      res = [["Item", "Description", "Unit Cost", "Quantity", "Line Total"]]

      items = @invoice.invoice_items.map do |item|
        items_data(item.invoiceable)
      end

      res + items + [[" ", " ", " ", " ", " "]]
    end

    def items_data(item)
      case item.class.name
        when 'Bom'
          [
              item.material.name,
              item.material.description,
              @view.humanized_money_with_symbol(item.price),
              item.quantity,
              @view.humanized_money_with_symbol(item.total_price)
          ]
        else
          [
              item.name,
              item.description,
              @view.humanized_money_with_symbol(item.amount),
              '1',
              @view.humanized_money_with_symbol(item.amount)
          ]
      end

    end


  end
end