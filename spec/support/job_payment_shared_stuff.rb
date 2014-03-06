shared_examples 'payment successfully collected' do |the_billing_status, the_subcon_collection, the_prov_collection|
  it 'payment status should be correct' do
    expect(collection_job.billing_status_name).to eq send(the_billing_status)
  end

  it 'subcon collection status should be correct' do
    expect(collection_job.subcon_collection_status_name).to eq send(the_subcon_collection) unless send(the_subcon_collection).nil?
  end

  it 'provider collection status should be correct' do
    unless send(the_prov_collection).nil?
      if collection_job.prov_collection_status.nil?
        expect(send(the_prov_collection)).to be_nil
      else
        expect(collection_job.reload.prov_collection_status_name).to eq send(the_prov_collection)
      end
    end

  end

  it 'collect event is associated with the job' do
    collection_job.events.map { |e| e.class.name }.should =~ job_events.map(&:name)
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

shared_examples 'successful customer payment collection' do

  # this shared context expect the following let statements from the calling context
  # let(:collection_job) { subcon_job }
  # let(:collector) { subcon_admin }
  # let(:billing_status) { :na } # since the job is not done it is set to partial
  # let(:billing_status_4_cash) { :na } # since the job is not done it is set to partial
  # let(:subcon_collection_status) { :na }
  # let(:subcon_collection_status_4_cash) { :na }
  # let(:prov_collection_status) { :partially_collected }
  # let(:prov_collection_status_4_cash) { :partially_collected }
  #
  # let(:customer_balance_before_payment) { 0 }
  # let(:payment_amount) { 10 }
  # let(:job_events) { [ServiceCallReceivedEvent,
  #                     ServiceCallAcceptEvent,
  #                     ScCollectEvent] }

  context 'when collecting cash' do

    before do
      collection_job.update_attributes(billing_status_event: 'collect',
                                       payment_type:         'cash',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
      collection_job.payment_amount = nil # to simulate a new user request by clearing virtual attr
    end

    it_behaves_like 'payment successfully collected', 'billing_status_4_cash', 'subcon_collection_status_4_cash', 'prov_collection_status_4_cash'

    it_behaves_like 'customer billing is successful', :cleared, []
  end

  context 'when collecting credit card' do
    before do
      collection_job.update_attributes(billing_status_event: 'collect',
                                       payment_type:         'credit_card',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected', 'billing_status', 'subcon_collection_status', 'prov_collection_status'

    it_behaves_like 'customer billing is successful', :pending, [:deposit, :clear, :reject]

  end

  context 'when collecting amex' do
    before do
      collection_job.update_attributes(billing_status_event: 'collect',
                                       payment_type:         'amex_credit_card',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected', 'billing_status', 'subcon_collection_status', 'prov_collection_status'

    it_behaves_like 'customer billing is successful', :pending, [:deposit, :clear, :reject]

  end

  context 'when collecting cheque' do
    before do
      collection_job.update_attributes(billing_status_event: 'collect',
                                       payment_type:         'cheque',
                                       payment_amount:       payment_amount.to_s,
                                       collector:            collector)
    end

    it_behaves_like 'payment successfully collected', 'billing_status', 'subcon_collection_status', 'prov_collection_status'

    it_behaves_like 'customer billing is successful', :pending, [:deposit, :clear, :reject]

  end

  context 'when prov cancels' do
    include_context 'when the provider cancels the job'
    it_should_behave_like 'provider job is canceled'
    it_should_behave_like 'provider job canceled after completion'
  end

end

