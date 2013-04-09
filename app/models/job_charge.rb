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

class JobCharge < PostingRule

  def get_entries(event)
    @ticket = event.eventable
    @event  = event
    case event.class.name
      when ServiceCallCompletedEvent.name, ServiceCallCompleteEvent.name
        customer_entries
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name
        cancellation_entries
      else
        raise "Unexpected Event to be processed by JobCharge posting rule"

    end

  end

  def customer_entries
    [
        ServiceCallCharge.new(event: @event,
                              ticket: @ticket,
                              amount: charge_amount,
                              description: "Entry to provider owned account")
    ]
  end

  def cancellation_entries
    [

        CanceledJobAdjustment.new(event:       @event,
                                  ticket:      @ticket,
                                  amount:      -charge_amount,
                                  description: "Reimbursement for a canceled job")
    ]
  end

  def charge_amount
    @ticket.total_price - (@ticket.total_price * (rate / 100.0))
  end

  def applicable?(event)
    case event.class.name
      when ServiceCallCompletedEvent.name, ServiceCallCompleteEvent.name
        true
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name
        true
      else
        false
    end

  end

end
