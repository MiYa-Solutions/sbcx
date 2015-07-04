class CustomerAccount < Account

  def open_job_entries
    AccountingEntry.joins(:ticket).
        where('tickets.billing_status NOT in (?)', [CustomerJobBilling::STATUS_PAID, CustomerJobBilling::STATUS_CLEARED]).
        where('tickets.work_status = ?', ServiceCall::WORK_STATUS_DONE).
        where('accounting_entries.account_id = ?', self.id).all
  end

  def statement_tickets
    completed_work_tickets + adv_paymnet_tickets + adj_entry_tickets
  end

  private

  def completed_work_tickets
    Ticket.where(customer_id: accountable_id).
        where('tickets.billing_status NOT in (?)', [CustomerJobBilling::STATUS_PAID, CustomerJobBilling::STATUS_CLEARED]).
        where('tickets.work_status = ?', ServiceCall::WORK_STATUS_DONE).
        where('tickets.organization_id = ?', organization_id).
        where('tickets.status != ?', ServiceCall::STATUS_CANCELED).all
  end

  def adv_paymnet_tickets
    Ticket.where(customer_id: accountable_id).joins(:accounting_entries).
        where('accounting_entries.type = ?', 'AdvancePayment').all
  end

  def adj_entry_tickets
    Ticket.where(customer_id: accountable_id).joins(:accounting_entries).
        where('accounting_entries.type IN (?)', [MyAdjEntry, ReceivedAdjEntry]).
        where('accounting_entries.status IN (?)', [AdjustmentEntry::STATUS_SUBMITTED, AdjustmentEntry::STATUS_REJECTED] ).all
  end

end