module InitiatedDepositableEntry
  extend ActiveSupport::Concern

  included do
    state_machine :status do

      event :rejected do
        transition :deposited => :rejected
      end

      event :cleared do
        transition :deposited => :cleared
      end

      event :deposited do
        transition :confirmed => :deposited
      end

    end

  end
end