shared_examples 'payment successfully collected' do |the_status, avail_events|
  it 'payment status should be correct' do
    expect(collection_job.billing_status_name).to eq send(the_status)
  end

  it 'available payment events are the expected ones' do
    collection_job.billing_status_events.should =~ send(avail_events)
  end

  it 'collect event is associated with the job' do
    collection_job.events.map(&:class).should =~ job_events
  end
end

shared_examples 'customer billing is successful' do |entry_status, entry_status_events|

  let(:customer_entry) { collection_job.payments.order('ID ASC').last }
  it 'customer balance should be correct' do
    expect(collection_job.customer.account.reload.balance).to eq Money.new((customer_balance_before_payment - payment_amount)*100)
  end

  it 'entry should have the expected collector' do
    expect(customer_entry.collector).to eq collector
  end

  it 'entry status should be correct' do
    expect(customer_entry.status_name).to eq entry_status
  end

  it 'entry status events should be correct' do
    expect(customer_entry.status_events).to eq entry_status_events
  end

  it 'entry amount should be the payment amount' do
    expect(customer_entry.amount).to eq Money.new(-payment_amount*100)
  end


end

shared_examples 'successful customer payment collection' do |collection_event|

  # this shared context expect the following let statements from the calling context
  # collector e.g. let(:collector) {org_admin}
  # collection_job e.g. let(:collector) {org_admin}
  # payment_amount e.g. let(:payment_amount) {100}
  # billing_status, e.g. let(:billing_status_events) { [:paid, :collect]}
  # billing_status_events
  # customer_balance_before_payment
  # payment_amount
  # job_events - the events expected to be associated with the job
  #              e.g. [ServiceCallDispatchEvent,ServiceCallStartEvent, ScCollectedByEmployeeEvent]
  #

  context 'when collecting cash' do

    before do
      collection_job.update_attributes(billing_status_event: collection_event,
                                       payment_type:         'cash',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected', 'billing_status_4_cash', 'billing_status_events_4_cash'

    it_behaves_like 'customer billing is successful', :cleared, []
  end

  context 'when collecting credit card' do
    before do
      collection_job.update_attributes(billing_status_event: collection_event,
                                       payment_type:         'credit_card',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected', 'billing_status', 'billing_status_events'

    it_behaves_like 'customer billing is successful', :pending, [:deposit, :clear, :reject]

  end

  context 'when collecting amex' do
    before do
      collection_job.update_attributes(billing_status_event: collection_event,
                                       payment_type:         'amex_credit_card',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected', 'billing_status', 'billing_status_events'

    it_behaves_like 'customer billing is successful', :pending, [:deposit, :clear, :reject]

  end

  context 'when collecting cheque' do
    before do
      collection_job.update_attributes(billing_status_event: collection_event,
                                       payment_type:         'cheque',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected', 'billing_status', 'billing_status_events'

    it_behaves_like 'customer billing is successful', :pending, [:deposit, :clear, :reject]

  end

  context 'when prov cancels' do
    include_context 'when the provider cancels the job'
    it_should_behave_like 'provider job is canceled'
    it_should_behave_like 'provider job canceled after completion'
  end

end

