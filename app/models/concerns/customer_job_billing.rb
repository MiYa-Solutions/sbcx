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
        transition [:partially_collected, :in_process] => :rejected, if: ->(sc) { !sc.canceled? }
        transition [:in_process, :collected] => :over_paid, if: ->(sc) { sc.canceled? && sc.outstanding_payments_cleared? }
        transition [:in_process, :collected] => :paid, if: ->(sc) { sc.canceled? && !sc.outstanding_payments? }
      end

      event :late do
        transition [:pending, :partially_collected, :rejected] => :overdue, if: ->(sc) { !sc.canceled? }
      end

      event :collect do
        transition :partially_collected => :in_process, if: ->(sc) { sc.fully_paid? && sc.any_payment_deposited? }

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

        transition :overdue => :partially_collected, if: ->(sc) { !sc.fully_paid? && !sc.canceled? && (sc.customer_balance <= 0) }
        transition :overdue => :overdue, if: ->(sc) { !sc.fully_paid? && !sc.canceled? && (sc.customer_balance > 0) }
      end

      event :deposited do
        transition [:in_process, :collected] => :over_paid, if: ->(sc) { sc.overpaid? && !sc.payment_pending_process? }
        transition [:in_process, :collected] => :paid, if: ->(sc) { sc.fully_cleared? && !sc.payment_pending_process? }
        transition :collected => :in_process, if: ->(sc) { sc.fully_paid? }
      end

      event :reimburse do
        transition :over_paid => :paid
      end

      event :cancel do
        transition [:partially_collected, :overdue, :rejected] => :over_paid, if: ->(sc) { sc.outstanding_payments_cleared? }
        transition [:partially_collected, :overdue, :rejected] => :in_process, if: ->(sc) { sc.outstanding_payments_deposited? }
        transition [:partially_collected, :overdue, :rejected] => :collected, if: ->(sc) { sc.payment_pending_process? }
        transition [:overdue, :rejected] => :paid, if: ->(sc) { !sc.outstanding_payments? }
        transition :paid => :over_paid
      end

    end

  end

  def overpaid?
    current_payment = payment_amount || 0
    total.cents - (cleared_payment_cents.abs + current_payment.to_f * 100) < 0
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

  def any_payment_deposited?
    payments.with_status(:deposited).size > 0
  end

  def any_payment_cleared?
    payments.with_status(:cleared).size > 0
  end

  def any_payment_rejected?
    payments.without_status(:rejected).size > 0
  end

  def payment_pending_process?
    payments.with_status([:pending, :deposited]).size > 0
  end

  def outstanding_payments_cleared?
    !payment_pending_process? && any_payment_cleared?
  end

  def outstanding_payments_deposited?
    any_payment_deposited? && !(payments.with_status(:pending).size > 0)
  end

  def outstanding_payments?
    payments.with_status([:pending, :deposited, :cleared]).size > 0
  end


  alias_method :payment_cleared?, :fully_cleared?

  private

  def cleared_payment_cents
    payments.with_status(:cleared).sum(:amount_cents).abs
  end

end