module ConfirmableEntry
  extend ActiveSupport::Concern

  included do
    STATUS_ACCEPTED  = 8001
    STATUS_REJECTED  = 8002
    STATUS_CANCELED  = 8003
    STATUS_SUBMITTED = 8004


    state_machine :status do
      state :canceled, value: STATUS_CANCELED
      state :cleared, value: AccountingEntry::STATUS_CLEARED # reserved only when the affiliate is not a member
      state :rejected, value: STATUS_REJECTED
      state :accepted, value: STATUS_ACCEPTED
      state :submitted, value: STATUS_SUBMITTED


      event :cancel do
        transition :rejected => :canceled
      end
    end

  end

end