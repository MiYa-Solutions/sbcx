class StatementSerializer
  def self.user_input_map
    {
        simple: CustomerStatementSerializer
    }
  end

  class CustomerStatementSerializer
    attr_accessor :customer

    def initialize(statementable)
      @customer = statementable
      @tickets = statementable.statementable_tickets
      @account = Account.for(@tickets.first.organization, statementable).first
    end

    def serialize
      res = {}
      res[:totals] = statement_totals
      res[:customer] = customer_data
      res[:tickets] = tickets_data
      res
    end

    private

    def statement_totals
      {
          balance: statement_balance
      }
    end

    def customer_data
      {
          name: @customer.name,
          address1: @customer.address1
      }
    end

    def statement_balance
      balance = @tickets.sum(&:customer_balance)

      {
          cents: balance.cents,
          ccy_code: balance.currency.iso_code,
          ccy_symbol: balance.currency.symbol

      }

    end

    def tickets_data
      res = []
      @tickets.each do |ticket|
        res << get_ticket_data(ticket)
      end
      res
    end

    def get_ticket_data(ticket)
      res = {id: ticket.id.to_s, balance_cents: ticket.customer_balance.cents.to_s}
      res.merge! serialize_boms(ticket)
      res.merge! serialize_entries(ticket)
    end

    def serialize_boms(ticket)
      res = {boms: []}
      ticket.boms.each do |bom|
        res[:boms] << {id: bom.id.to_s, price_cents: bom.total_price.cents.to_s, cost_cents: bom.total_cost.cents.to_s}
      end
      res
    end

    def serialize_entries(ticket)
      res = {entries: []}
      ticket.entries.where(account_id: @account.id).each do |e|
        res[:entries] << {id: e.id, type: e.type, amount_cents: e.amount_cents, description: e.description, notes: e.notes}
      end
      res
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