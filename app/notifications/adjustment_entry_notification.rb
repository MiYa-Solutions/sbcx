class AdjustmentEntryNotification < Notification

  def entry_link
    link_to AdjustmentEntry.model_name.human.downcase, url_helpers.accounting_entry_path(entry)
  end

  def entry
    @entry ||= event.entry
  end

  def affiliate
    event.entry.account.accountable
  end


end