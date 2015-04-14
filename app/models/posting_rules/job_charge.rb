# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer          not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  properties     :hstore
#  time_bound     :boolean          default(FALSE)
#  sunday         :boolean          default(FALSE)
#  monday         :boolean          default(FALSE)
#  tuesday        :boolean          default(FALSE)
#  wednesday      :boolean          default(FALSE)
#  thursday       :boolean          default(FALSE)
#  friday         :boolean          default(FALSE)
#  saturday       :boolean          default(FALSE)
#  sunday_from    :time
#  monday_from    :time
#  tuesday_from   :time
#  wednesday_from :time
#  thursday_from  :time
#  friday_from    :time
#  saturday_from  :time
#  sunday_to      :time
#  monday_to      :time
#  tuesday_to     :time
#  wednesday_to   :time
#  thursday_to    :time
#  friday_to      :time
#  saturday_to    :time
#

class JobCharge < CustomerPostingRule

  def get_entries(event)
    @ticket = event.eventable
    @event  = event
    case event.class.name
      when ServiceCallCompletedEvent.name, ServiceCallCompleteEvent.name
        customer_entries
      when ScCollectEvent.name, ScCollectedEvent.name
        collection_entries
      when ScWorkReopenEvent.name
        work_reopen_entries
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name
        cancellation_entries
      when ScCustomerReimbursementEvent.name
        reimbursement_entries
      else
        raise "Unexpected Event to be processed by JobCharge posting rule"

    end

  end

  def customer_entries
    [
        ServiceCallCharge.new(event:       @event,
                              ticket:      @ticket,
                              status:      AccountingEntry::STATUS_CLEARED,
                              amount:      charge_amount,
                              agreement:   agreement,
                              description: 'Service Charge')
    ]
  end

  def work_reopen_entries
    amount       = ServiceCallCharge.where(ticket_id: @ticket.id).order('id asc').last
    amount_cents = amount ? amount.amount_cents : 0
    if amount_cents > 0
      amount_ccy = amount ? amount.amount_currency : 'USD'
      [

          MyAdjEntry.new(event:           @event,
                         status:          AccountingEntry::STATUS_CLEARED,
                         ticket:          @ticket,
                         amount_cents:    -amount_cents,
                         amount_currency: amount_ccy,
                         matching_entry:  amount,
                         agreement:       agreement,
                         description:     'Adjustment due to reopening the job')
      ]
    else
      []
    end

  end

  def cancellation_entries
    amount       = ServiceCallCharge.where(ticket_id: @ticket.id).order('id asc').last
    amount_cents = amount ? amount.amount_cents : 0
    if amount_cents > 0
      amount_ccy = amount ? amount.amount_currency : 'USD'
      [

          CanceledJobAdjustment.new(event:           @event,
                                    status:          AccountingEntry::STATUS_CLEARED,
                                    ticket:          @ticket,
                                    amount_cents:    -amount_cents,
                                    amount_currency: amount_ccy,
                                    agreement:       agreement,
                                    description:     'Reimbursement for a canceled job')
      ]
    else
      []
    end
  end

  def charge_amount
    (@ticket.total_price - (@ticket.total_price * (rate / 100.0))) + @ticket.total_price * (@ticket.tax / 100.0) -
        Money.new(@ticket.entries.where(type: 'AdvancePayment').sum(:amount_cents))
  end

  def applicable?(event)
    case event.class.name
      when ServiceCallCompletedEvent.name, ServiceCallCompleteEvent.name
        true
      when ScWorkReopenEvent.name
        true
      when ScCollectEvent.name, ScCollectedEvent.name
        true
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name
        true
      when ScCustomerReimbursementEvent.name
        true
      else
        false
    end

  end

  private

  def collection_entries

    props = { amount:      -@event.amount,
              ticket:      @ticket,
              event:       @event,
              notes:       @event.notes,
              agreement:   agreement,
              description: I18n.t("payment.#{@event.payment_type}.description", ticket: @ticket.id).html_safe }

    if @event.collector
      props[:collector] = @event.collector
    else
      props[:collector] = @ticket.collector ? @ticket.collector : @ticket.organization
    end

    # if the collector is the subcon update matching collection entry
    if @ticket.subcontractor && (props[:collector].becomes(Organization) == @ticket.subcontractor.becomes(Organization))
      props[:matching_entry] = @event.accounting_entries.where(type: CollectedEntry.subclasses.map(&:name)).first
    end


    case @event.payment_type
      when 'cash'
        entry = CashPayment.new(props)
      when 'credit_card'
        entry = CreditPayment.new(props)
      when 'amex_credit_card'
        entry = AmexPayment.new(props)
      when 'cheque'
        entry = ChequePayment.new(props)
      else
        raise "#{self.class.name}: Unexpected payment type (#{@event.payment_type}) when processing the event"
    end

    [entry]

  end

  def reimbursement_entries
    the_amount = Money.new(@ticket.payments.with_status(:cleared).sum(:amount_cents).abs - @ticket.total.cents, @ticket.total.currency)

    props = { amount:      the_amount,
              ticket:      @ticket,
              status:      AccountingEntry::STATUS_CLEARED,
              event:       @event,
              agreement:   agreement,
              description: I18n.t('accounting_entry.description.customer_reimbursement', amount: the_amount) }


    [CustomerReimbursement.new(props)]
  end

end
