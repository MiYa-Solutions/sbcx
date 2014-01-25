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

shared_context 'reject payment' do
  let(:payment_to_reject) { entry || raise("you need to pass a let(:entry) when including reject payment context") }
  let(:the_job) { job || raise("you need to pass a let(:job) when including reject payment context") }
  before do
    payment_to_reject.reject!
  end

  it 'entry status should be rejected' do
    expect(payment_to_reject.status_name).to eq :rejected
  end

  it 'deposit and clear are the available status events' do
    expect(payment_to_reject.status_events).to eq [:deposit, :clear]
  end
end