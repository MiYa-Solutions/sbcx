shared_examples 'payment successfully collected' do
  it 'payment status should be correct' do
    expect(collection_job.billing_status_name).to eq billing_status
  end

  it 'available payment events are the expected ones' do
    collection_job.billing_status_events.should =~ billing_status_events
  end

  it 'collect event is associated with the job' do
    collection_job.events.map(&:class).should =~ job_events
  end
end

shared_examples 'customer billing is successful' do |entry_status, entry_type|

  let(:customer_entry) { collection_job.payments.order('ID ASC').last }
  it 'customer balance should be correct' do
    expect(collection_job.customer.account.reload.balance).to eq Money.new((customer_balance_before_payment - payment_amount)*100)
  end

  it 'entry should have the expected collector' do
    expect(customer_entry.collector).to eq collector
  end

  it 'entry should be of the right type ' do
    expect(customer_entry).to be_instance_of entry_type
  end

  it 'entry status should should be correct' do
    expect(customer_entry.status_name).to eq entry_status
  end

  it 'entry amount should be the payment amount' do
    expect(customer_entry.amount).to eq Money.new(-payment_amount*100)
  end


end

shared_examples 'successful customer payment collection' do

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

  it 'collect is one of the billing events' do
    expect(collection_job.billing_status_events).to include(:collect)
  end

  context 'when collecting cash' do

    before do
      collection_job.update_attributes(billing_status_event: 'collect',
                                       payment_type:         'cash',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected'

    it_behaves_like 'customer billing is successful', :cleared
  end

  context 'when collecting credit card' do
    before do
      job.update_attributes(billing_status_event: 'collect',
                            payment_type:         'credit_card',
                            payment_amount:       payment_amount.to_s,
                            collector:            collector)
    end

    it_behaves_like 'payment successfully collected'

    it_behaves_like 'customer billing is successful', :pending

  end

  context 'when collecting amex' do
    before do
      job.update_attributes(billing_status_event: 'collect',
                            payment_type:         'amex_credit_card',
                            payment_amount:       payment_amount.to_s,
                            collector:            collector)
    end

    it_behaves_like 'payment successfully collected'

    it_behaves_like 'customer billing is successful', :pending

  end

  context 'when collecting cheque' do
    before do
      job.update_attributes(billing_status_event: 'collect',
                            payment_type:         'cheque',
                            payment_amount:       payment_amount.to_s,
                            collector:            collector)
    end

    it_behaves_like 'payment successfully collected'

    it_behaves_like 'customer billing is successful', :pending

  end

  context 'when prov cancels' do
    include_context 'when the provider cancels the job'
    it_should_behave_like 'provider job is canceled'
    it_should_behave_like 'provider job canceled after completion'
  end

end

