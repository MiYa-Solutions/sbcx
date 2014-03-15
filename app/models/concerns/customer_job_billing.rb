module CustomerJobBilling
  extend ActiveSupport::Concern

  STATUS_PENDING             = 4100
  STATUS_COLLECTED           = 4102
  STATUS_OVERDUE             = 4103
  STATUS_PAID                = 4104
  STATUS_CLEARED             = 4108
  STATUS_REJECTED            = 4109
  STATUS_PARTIALLY_COLLECTED = 4110
  STATUS_OVERPAID            = 4113
  STATUS_IN_PROCESS          = 4114

  included do

    state_machine :billing_status, initial: :pending, namespace: 'payment' do
      state :pending, value: STATUS_PENDING
      state :overdue, value: STATUS_OVERDUE
      state :paid, value: STATUS_PAID
      state :rejected, value: STATUS_REJECTED
      state :partially_collected, value: STATUS_PARTIALLY_COLLECTED
      state :collected, value: STATUS_COLLECTED
      state :in_process, value: STATUS_IN_PROCESS
      state :over_paid, value: STATUS_OVERPAID

      after_failure do |service_call, transition|
        Rails.logger.debug { "My Service Call billing status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
      end

      event :clear do
        transition :in_process => :over_paid, if: ->(sc) { sc.overpaid? }
        transition :in_process => :paid, if: ->(sc) { sc.fully_cleared? }
      end

      event :reject do
        transition :in_process => :rejected
      end

      event :late do
        transition [:pending, :partially_collected, :rejected] => :overdue, if: ->(sc) { !sc.canceled? }
      end

      event :collect do
        transition [:pending,
                    :rejected,
                    :overdue,
                    :partially_collected
                   ]   => :collected,

                   if: ->(sc) { sc.fully_paid? && !sc.canceled? }

        transition [:pending,
                    :rejected,
                    :partially_collected
                   ]   => :partially_collected,

                   if: ->(sc) { !sc.fully_paid? && !sc.canceled? }

        transition :overdue => :overdue, if: ->(sc) { !sc.fully_paid? && !sc.canceled? }
      end

      event :deposited do
        transition [:in_process, :collected] => :over_paid, if: ->(sc) { !sc.canceled? && sc.overpaid? }
        transition [:in_process, :collected] => :paid, if: ->(sc) { !sc.canceled? && sc.fully_cleared? }
        transition :collected => :in_process, if: ->(sc) { !sc.canceled? && sc.fully_paid? }
      end

      event :mark_as_fully_paid do
        transition :partially_collected => :paid, if: ->(sc) { sc.fully_paid? }
      end

      event :mark_as_overpaid do
        transition :partially_collected => :overpaid, if: ->(sc) { sc.overpaid? }
      end

    end

  end

  def overpaid?
    current_payment = payment_amount || 0
    total.cents + (cleared_payment_cents - current_payment.to_f * 100) < 0
  end

  def check_and_set_as_fully_paid
    if overpaid?
      mark_as_over_paid!
    else
      mark_as_fully_paid_payment if fully_paid?
    end
  end

  def paid_amount
    Money.new(payments.with_statuses(:pending, :deposited, :cleared).sum(:amount_cents), total.currency)
  end

  def payments
    entries.where(type: AccountingEntry.payment_entry_classes)
  end

  def fully_cleared?
    cleared_payment_cents >= total.cents
  end

  alias_method :payment_cleared?, :fully_cleared?

  private

  def cleared_payment_cents
    payments.with_status(:cleared).sum(:amount_cents).abs
  end

end