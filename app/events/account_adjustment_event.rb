class AccountAdjustmentEvent < AdjustmentEvent

  setup_hstore_attr 'matching_entry_id'

  def init
    self.name         = I18n.t('account_adjustment_event.name')
    self.description  = I18n.t('account_adjustment_event.description')
    self.reference_id = 300000
  end

  def process_event
    update_entry_with_event
    affiliate_account.events <<
        AccountAdjustedEvent.new(triggering_event: self)
  end

  def affiliate_entry_id
    self.matching_entry_id
  end


  private

  def update_entry_with_event
    entry.event = self
    entry.save!
  end

end
