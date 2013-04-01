class AdjustmentEntry < AccountingEntry
  before_save :convert_ticket_ref_id
  validate :check_ticket_ref_id
  validates_numericality_of :ticket_ref_id
  attr_writer :ticket_ref_id

  def ticket_ref_id
    @ticket_ref_id || ticket.try(:ref_id)
  end
  def amount_direction
    1
  end

  def validate_ticket_id?
    false
  end

  private
  def the_ticket
    @the_ticket ||= find_the_ticket
  end

  def find_the_ticket
    Ticket.where("organization_id = ? AND ref_id = ?", account.organization.id, ticket_ref_id).first if ticket_ref_id.to_i > 0
  end
  def convert_ticket_ref_id
    self.ticket = the_ticket
  end

  def check_ticket_ref_id
    errors.add :ticket_ref_id, "Invalid ticket reference" if the_ticket.nil?
  end

end