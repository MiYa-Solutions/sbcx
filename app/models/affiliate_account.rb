class AffiliateAccount < Account
  def open_job_entries
    AccountingEntry.joins(:ticket).
        where('tickets.subcontractor_status NOT in (?) OR tickets.provider_status in (?)',
              [AffiliateSettlement::STATUS_CLEARED, AffiliateSettlement::STATUS_SETTLED, AffiliateSettlement::STATUS_NA],
              [AffiliateSettlement::STATUS_CLEARED, AffiliateSettlement::STATUS_CLEARED, AffiliateSettlement::STATUS_NA] ).
        where('tickets.work_status = ?', ServiceCall::WORK_STATUS_DONE).
        where('tickets.organization_id = ?', organization_id).
        where('accounting_entries.account_id = ?', self.id).all
  end

end