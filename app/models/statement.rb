class Statement < ActiveRecord::Base
  validates_presence_of :data, :account
  belongs_to :account
  attr_accessor :notes
  attr_accessor :exclude_zero_balance


  def save(serializer)
    self.data = serializer.new(account, notes: notes,
                               exclude_zero_balance: exclude_zero_balance).serialize.to_json
    super()
  end

  def user_notes
    data ? data_hash['general']['notes'] : ''
  end

  def statementable_name
    account.accountable.name
  end

  def statementable_address1
    account.accountable.address1
  end

  def statementable_address2
    account.accountable.address2
  end

  def statementable_city
    account.accountable.city
  end

  def statementable_state
    account.accountable.state
  end

  def statementable_zip
    account.accountable.zip
  end

  def statementable_company
    account.accountable.company
  end

  def statementable_phone
    account.accountable.phone
  end

  def statementable_email
    account.accountable.email
  end

  def organization
    @organization ||= account.organization
  end

  def balance
    @balance ||= Money.new(data_hash['totals']['balance']['cents'], data_hash['totals']['balance']['ccy_code'])
  end

  def tickets
    @tickets ||= deserialize_tickets
  end

  def entries
    data_hash['entries']
  end

  private

  def data_hash
    @data_hash ||= JSON.parse(data)
  end

  def deserialize_tickets
    data_hash['tickets'].map do |t|
      OpenStruct.new(id:           t['id'],
                     name:         t['name'],
                     ref_id:       t['ref_id'],
                     external_ref: t['external_ref'],
                     balance:      Money.new(t['balance_cents'], t['balance_ccy']),
                     completed_on: t['completed_on'].present? ? Time.zone.parse(t['completed_on']) : '',
                     entries:      deserialize_ticket_entries(t))
    end
  end

  def deserialize_ticket_entries(ticket)
    ticket['entries'].collect do |e|
      OpenStruct.new(id:          e['id'],
                     type:        e['type'],
                     description: e['description'],
                     amount:      Money.new(e['amount_cents'], e['amount_ccy']),
                     description: e['description'],
                     notes:       e['notes'],
                     ticket_id:   e['ticket_id']
      )
    end
  end

end
