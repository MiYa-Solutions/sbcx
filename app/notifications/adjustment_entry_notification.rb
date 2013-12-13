class AdjustmentEntryNotification < Notification
  alias_method :entry, :notifiable

  def entry_link
    link_to AccountingEntry.model_name.human.downcase, url_helpers.accounting_entry_path(entry)
  end


end