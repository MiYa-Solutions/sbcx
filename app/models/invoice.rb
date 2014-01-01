class Invoice

  def initialize(job)
    @job     = job
    @company = job_owner
  end

  def generate_pdf(view)
    InvoicePdf.new(self, view).render
  end

  def company_logo
    'LogoImg.png'
  end

  def customer_name
    @job.customer.name || ''
  end

  def customer_company
    @job.customer.company || ''
  end

  def customer_address1
    @job.customer.address1 || ''
  end

  def customer_address2
    @job.customer.address2 || ''
  end

  def customer_city
    @job.customer.city || ''
  end

  def customer_state
    @job.customer.state || ''
  end

  def customer_phone
    @job.customer.phone || ''
  end

  def customer_zip
    @job.customer.zip || ''
  end

  def number
    @job.ref_id || ''
  end

  def date
    event = @job.events.where(reference_id: 100018).first
    event ? event.created_at : Time.zone.now
  end

  def total_before_tax
    @job.total_price
  end

  def total
    @job.total_price + @job.tax_amount
  end

  def tax
    @job.tax
  end

  def tax_amount
    @job.tax_amount
  end

  def company_name
    @company.company
  end

  def company_address1
    @company.address1
  end

  def company_address2
    @company.address2
  end

  def company_city_and_state
    "#{@company.city}, #{@company.state} #{@company.zip}"
  end

  def boms
    @job.boms
  end

  private

  def job_owner
    member_job = MyServiceCall.find_by_ref_id @job.ref_id
    if member_job.nil?
      res = TransferredServiceCall.where(ref_id: @job.ref_id).order('id desc').first.provider
    else
      res = member_job.organization
    end
    res
  end


  class InvoicePdf < Prawn::Document
    def initialize(invoice, view)
      super()
      @invoice          = invoice
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
      text_box @invoice.company_address2, :at => [address_x, cursor]
      move_down lineheight_y
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
      text_box @invoice.customer_name, :at => [address_x, cursor]
      move_down lineheight_y
      text_box @invoice.customer_address1, :at => [address_x, cursor]
      move_down lineheight_y
      text_box @invoice.customer_address2, :at => [address_x, cursor]
      move_down lineheight_y
      text_box "#{@invoice.customer_state}, #{@invoice.customer_city} #{@invoice.customer_zip}", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "Phone: #{@invoice.customer_phone}", :at => [address_x, cursor]

      move_cursor_to last_measured_y - (2 * lineheight_y)

    end

    def invoice_summary
      invoice_header_data = [
          ["Invoice #", @invoice.number],
          ["Invoice Date", @view.l(@invoice.date, format: :date_only)],
          ["Amount Due", @view.humanized_money_with_symbol(@invoice.total)]
      ]

      table(invoice_header_data, :position => invoice_header_x, :width => 215) do
        style(row(0..1).columns(0..1), :padding => [1, 5, 1, 5], :borders => [])
        style(row(2), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
        style(column(1), :align => :right)
        style(row(2).columns(0), :borders => [:top, :left, :bottom])
        style(row(2).columns(1), :borders => [:top, :right, :bottom])
      end

    end

    def items_table
      move_down 45

      table(bom_data, :width => bounds.width) do
        style(row(1..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'dddddd')
        style(row(0), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
        style(row(0).columns(0..-1), :borders => [:top, :bottom])
        style(row(0).columns(0), :borders => [:top, :left, :bottom])
        style(row(0).columns(-1), :borders => [:top, :right, :bottom])
        style(row(-1), :border_width => 2)
        style(column(2..-1), :align => :right)
        style(columns(0), :width => 75)
        style(columns(1), :width => 275)
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


    def bom_data
      res = [["Item", "Description", "Unit Cost", "Quantity", "Line Total"]]

      boms = @invoice.boms.map do |bom|
        [
            bom.material.name,
            bom.material.description,
            @view.humanized_money_with_symbol(bom.price),
            bom.quantity,
            @view.humanized_money_with_symbol(bom.total_price)
        ]
      end

      res + boms + [[" ", " ", " ", " ", " "]]
    end


  end
end