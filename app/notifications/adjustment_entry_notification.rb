class AdjustmentEntryNotification < Notification
  alias_method :entry, :notifiable

  def entry_link
    link_to AdjustmentEntry.model_name.human.downcase, url_helpers.accounting_entry_path(entry)
  end

  def affiliate
    entry.account.accountable
  end


end