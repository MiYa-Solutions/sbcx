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

require 'spec_helper'

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

  pending 'inherits the agreement permissions'

  pending '#org_payment_entries and #cparty_payment_entries methods'

end
