class Invoice

  def initialize(job)
    @job = job
  end

  def generate_pdf(view)
    InvoicePdf.new(self, view).render
  end

  def logo
    'LogoImg.png'
  end

  class InvoicePdf < Prawn::Document
    def initialize(invoice, view)
      super()
      @invoice          = invoice
      @view             = view
      @address_x        = 35
      @lineheight_y     = 12
      @invoice_header_x = 325
      create_the_invoice
    end

    attr_reader :address_x
    attr_reader :lineheight_y
    attr_reader :invoice_header_x


    def create_the_invoice
      header
      client_address
      invoice_summary
      items_table
      footer
    end

    private

    def header
      logopath = "#{Rails.root}/app/assets/images/#{@invoice.logo}"

      move_down 5

      # Add the font style and size
      font "Helvetica"
      font_size 9

      #start with EON Media Group
      text_box "Your Business Name", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "1234 Some Street Suite 1703", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "Some City, ST 12345", :at => [address_x, cursor]
      move_down lineheight_y

      last_measured_y = cursor
      move_cursor_to bounds.height

      image logopath, :width => 215, :position => :right

      move_cursor_to last_measured_y

    end

    def client_address
      move_down 65

      last_measured_y = cursor

      text_box "Client Business Name", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "Client Contact Name", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "4321 Some Street Suite 1000", :at => [address_x, cursor]
      move_down lineheight_y
      text_box "Some City, ST 12345", :at => [address_x, cursor]

      move_cursor_to last_measured_y

    end

    def invoice_summary
      invoice_header_data = [
          ["Invoice #", "001"],
          ["Invoice Date", "December 1, 2011"],
          ["Amount Due", "$3,200.00 USD"]
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

      invoice_services_data = [
          ["Item", "Description", "Unit Cost", "Quantity", "Line Total"],
          ["Service Name", "Service Description", "320.00", "10", "$3,200.00"],
          [" ", " ", " ", " ", " "]
      ]

      table(invoice_services_data, :width => bounds.width) do
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
          ["Total", "$3,200.00"],
          ["Amount Paid", "-0.00"],
          ["Amount Due", "$3,200.00 USD"]
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

    def footer
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
          ["Thank you for doing business with Your Business Name"]
      ]

      table(invoice_notes_data, :width => 275) do
        style(row(0..-1).columns(0..-1), :padding => [1, 0, 1, 0], :borders => [])
        style(row(0).columns(0), :font_style => :bold)
      end
    end


  end
end