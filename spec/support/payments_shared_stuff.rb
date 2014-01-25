shared_context 'clear payment' do
  let(:payment_to_clear) { entry || raise("you need to pass a let(:entry) when including clear payment context") }
  let(:the_job) { job || raise("you need to pass a let(:job) when including clear payment context") }
  before do
    payment_to_clear.clear
  end

  it 'entry status should be cleared' do
    expect(payment_to_clear.status_name).to eq :cleared
  end

  it 'entry should have a PaymentClearedEvent associated' do
    expect(payment_to_clear.status_name).to eq :cleared
  end
end