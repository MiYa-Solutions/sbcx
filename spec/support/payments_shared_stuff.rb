shared_context 'clear payment' do
  let(:payment_to_clear) { entry || raise("you need to pass a let(:entry) when including clear payment context") }
  let(:the_job) { job || raise("you need to pass a let(:job) when including clear payment context") }
  before do
    payment_to_clear.clear!
  end

  it 'entry status should be cleared' do
    expect(payment_to_clear.status_name).to eq :cleared
  end

  it 'there should be no available payment events for the entry' do
    expect(payment_to_clear.status_events).to eq []
  end
end
shared_context 'deposit payment' do
  let(:payment_to_deposit) { entry || raise("you need to pass a let(:entry) when including clear payment context") }
  let(:status_after_deposit) { status || :deposited }
  let(:events) { available_events || [:reject, :clear] }
  before do
    payment_to_deposit.deposit!
  end

  it 'entry status should be cleared' do
    expect(payment_to_deposit.status_name).to eq status_after_deposit
  end

  it 'there should be no available payment events for the entry' do
    expect(payment_to_deposit.status_events).to eq events
  end
end


shared_context 'reject payment' do
  let(:payment_to_reject) { entry || raise("you need to pass a let(:entry) when including reject payment context") }
  let(:the_job) { job || raise("you need to pass a let(:job) when including reject payment context") }
  before do
    payment_to_reject.reject!
  end

  it 'entry status should be rejected' do
    expect(payment_to_reject.status_name).to eq :rejected
  end

  it 'there are no available status events - as the check bounced' do
    expect(payment_to_reject.status_events).to eq []
  end
end