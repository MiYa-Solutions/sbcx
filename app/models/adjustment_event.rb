# == Schema Information
#
# Table name: events
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  type                :string(255)
#  description         :text
#  eventable_type      :string(255)
#  eventable_id        :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#  reference_id        :integer
#  creator_id          :integer
#  updater_id          :integer
#  triggering_event_id :integer
#  properties          :hstore
#

require 'hstore_setup_methods'
class AdjustmentEvent < Event
  extend HstoreSetupMethods

  setup_hstore_attr 'entry_id'


  def process_event
    raise "process event was invoked on AccountingEvent - did you forget to implement it in the subclass?"
  end

  protected

  def account
    eventable
  end

  def affiliate_account
    Account.for_affiliate(affiliate, account.organization).first
  end

  def affiliate
    account.accountable
  end

  def entry
    @entry ||= AccountingEntry.find(entry_id)
  end


  def affiliate_entry_id
    Event.where(eventable_id:   account.id,
                eventable_type: 'Account',
                type:           %w(AccountAdjustedEvent AccountAdjustmentEvent)
    ).where("properties @> ('entry_id' => ?)", entry_id).first.matching_entry_id
  end

end
