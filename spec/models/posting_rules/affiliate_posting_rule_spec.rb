require 'rspec'

describe AffiliatePostingRule do

  let(:rule) { AffiliatePostingRule.new }

  [ServiceCallCompletedEvent.new,
   ScSubconSettleEvent.new,
   ScProviderSettleEvent.new,
   ScSubconSettledEvent.new,
   ScProviderSettledEvent.new,
   ServiceCallCancelEvent.new,
   ServiceCallCanceledEvent.new,
   ScCollectEvent.new,
   ServiceCallPaidEvent.new,
   ScCollectedEvent.new,
   ScProviderCollectedEvent.new].each do |event|
    it "should be applicable for #{event.class.name} event" do
      rule.applicable?(event).should be_true
    end
  end

  it ' ServiceCallCompleteEvent is only applicable when the job is transferred' do
    job   = FactoryGirl.build(:my_service_call)
    event = ServiceCallCompleteEvent.new(eventable: job)
    rule.applicable?(event).should be_false

    job.status = MyServiceCall::STATUS_TRANSFERRED
    rule.applicable?(event).should be_true

    job        = FactoryGirl.build(:transferred_sc_with_new_customer)
    job.status = MyServiceCall::STATUS_TRANSFERRED
    event      = ServiceCallCompleteEvent.new(eventable: job)
    rule.applicable?(event).should be_true
  end

  it 'should have a get_entries method' do
    should respond_to :get_entries
  end

  pending '#org_payment_entries and #cparty_payment_entries methods'

end