class StatementSerializer
  def self.user_input_map
    {
        simple: CustomerStatementSerializer
    }
  end

  class CustomerStatementSerializer
    attr_accessor :customer

    def initialize(account, notes: '', exclude_zero_balance: false)
      @account              = account
      # @entries = account.statement_entries
      @tickets              = account.statement_tickets
      @notes                = notes
      @exclude_zero_balance = exclude_zero_balance
    end

    def serialize
      res           = {}
      res[:general] = serialized_statement_general_data
      # res[:entries] = serialized_statement_entries
      res[:tickets] = serialized_tickets_data
      res[:totals]  = serialized_statement_totals
      res
    end

    private

    # def statement_tickets
    #   ids = []
    #   @entries.each do |e|
    #     unless ids.include? e.ticket_id
    #       ids << e.ticket_id
    #     end
    #   end
    #   Ticket.where(id: ids).all
    # end

    def serialized_statement_totals
      {
          balance: statement_balance
      }
    end

    def serialized_statement_general_data
      {
          name:     @account.accountable.name,
          address1: @account.accountable.address1,
          notes:    @notes
      }
    end

    def statement_balance
      if @tickets.size > 0
        balance = @tickets.sum(&:customer_balance)

      else
        balance = Money.new(0, 'USD')
      end

      {
          cents:      balance.cents,
          ccy_code:   balance.currency.iso_code,
          ccy_symbol: balance.currency.symbol

      }


    end

    def serialized_tickets_data
      # res = {}
      # @tickets.each do |ticket|
      #   res.store ticket.id, get_ticket_data(ticket)
      # end
      # res
      res = []
      sanitized_tickets.each do |ticket|
        res << get_ticket_data(ticket)
      end
      res
    end

    def get_ticket_data(ticket)
      res = {
          id:            ticket.id,
          name:          ticket.name,
          ref_id:        ticket.ref_id,
          external_ref:  ticket.external_ref,
          balance_cents: ticket.customer_balance.cents,
          balance_ccy:   ticket.customer_balance.currency.iso_code,
          completed_on:  ticket.completed_on ? ticket.completed_on.utc : nil,
          entries:       serialized_entries(ticket)
      }
      # res.merge! serialize_boms(ticket)
    end

    def serialized_entries(ticket)
      res = []
      ticket.entries.where(account_id: @account.id).each do |e|
        res << {
            id:           e.id,
            type:         e.class.model_name.human,
            amount_cents: e.amount_cents,
            amount_ccy:   e.amount.currency.iso_code,
            description:  e.description,
            notes:        e.notes,
            ticket_id:    e.ticket_id
        }
      end
      res
    end

    # def serialize_boms(ticket)
    #   res = {boms: []}
    #   ticket.boms.each do |bom|
    #     res[:boms] << {id: bom.id.to_s, price_cents: bom.total_price.cents.to_s, cost_cents: bom.total_cost.cents.to_s}
    #   end
    #   res
    # end

    def serialized_statement_entries
      res = []
      @entries.each do |e|
        res << { id: e.id, type: e.type, amount_cents: e.amount_cents, description: e.description, notes: e.notes, ticket_id: e.ticket_id }
      end
      res
    end

    def sanitized_tickets
      if @exclude_zero_balance
        @tickets.reject { |t| t.customer_balance == 0 }
      else
        @tickets
      end
    end


    # def self.get_data(ticket)
    #   res = {}
    #
    #   ticket.invoiceable_items.each do |item|
    #     res.merge! type: item.class.name, amount_cents: item.amount.to_s
    #   end
    #   res
    # end

  end
end