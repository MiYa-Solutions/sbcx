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
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name
        cancellation_entries
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
                              description: "Entry to provider owned account")
    ]
  end

  def cancellation_entries
    [

        CanceledJobAdjustment.new(event:       @event,
                                  status:      AccountingEntry::STATUS_CLEARED,
                                  ticket:      @ticket,
                                  amount:      -charge_amount,
                                  agreement:   agreement,
                                  description: "Reimbursement for a canceled job")
    ]
  end

  def charge_amount
    (@ticket.total_price - (@ticket.total_price * (rate / 100.0))) + @ticket.total_price * (@ticket.tax / 100.0)
  end

  def applicable?(event)
    case event.class.name
      when ServiceCallCompletedEvent.name, ServiceCallCompleteEvent.name
        true
      when ScCollectEvent.name, ScCollectedEvent.name
        true
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name
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
              agreement:   agreement,
              description: I18n.t("payment.#{@event.payment_type}.description", ticket: @ticket.id).html_safe }

    if @event.collector
      props[:collector] = @event.collector
    else
      props[:collector] = @ticket.collector ? @ticket.collector : @ticket.organization
    end


    case @event.payment_type
      when 'cash'
        entry = CashPayment.new(props)
        entry.status = AccountingEntry::STATUS_CLEARED
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

end
