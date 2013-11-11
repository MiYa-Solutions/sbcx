require 'spec_helper'

describe FlatFee do

  let(:rule) { FlatFee.new }
  subject { rule }


  it 'should have only na as the option' do
    rule.rate_types.should == [:na]
  end


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

  it 'should have a bom_reimbursement? method' do
    should respond_to :bom_reimbursement?
  end

  describe '#get_entries' do
    let(:bom1_cost) { 53.49 }
    let(:bom1_price) { 153 }
    let(:bom1_qty) { 2 }

    let(:bom2_cost) { 0.49 }
    let(:bom2_price) { 0.75 }
    let(:bom2_qty) { 1 }
    let(:subcon_flat_fee) { Money.new_with_amount(10) }


    let(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
    let(:org_admin_user3) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
    let(:org) { org_admin_user.organization }
    let(:org2) {
      setup_flat_fee_agreement(org_admin_user2.organization, org.becomes(Subcontractor))
      setup_flat_fee_agreement(org, org_admin_user2.organization.becomes(Subcontractor)).counterparty
    }
    let(:org3) do
      setup_profit_split_agreement(org_admin_user3.organization, org_admin_user.organization.becomes(Subcontractor))
      setup_profit_split_agreement(org2, org_admin_user3.organization.becomes(Subcontractor)).counterparty
    end
    let(:event) { job.events.first }

    #let(:rule) { org.agreements.where(counterparty_id: org2.id).first.posting_rules.first }

    describe 'for local subcon account' do
      let(:org) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]).organization }
      let(:subcon) { setup_flat_fee_agreement(org, FactoryGirl.create(:subcontractor)).counterparty }
      let(:account) { Account.for_affiliate(org, subcon).first }
      let(:agreement) { Agreement.our_agreements(org, subcon).first }
      let(:the_rule) { agreement.rules.first }
      let(:job) { FactoryGirl.create(:my_service_call, organization: org, subcontractor: nil) }

      before do
        job.subcon_agreement = agreement
        job.subcontractor    = subcon.becomes(Subcontractor)
        job.subcon_fee       = subcon_flat_fee
        job.transfer
        job.accept_work

        job.start_work

        add_bom_to_ticket(job, cost: bom1_cost, price: bom1_price, quantity: bom1_qty, buyer: job.organization)
        add_bom_to_ticket(job, cost: bom2_cost, price: bom2_price, quantity: bom2_qty, buyer: job.organization)

      end
      describe 'entries for CompleteEvent' do


        before do
          job.complete_work
        end

        it 'one entry for the subcon account with the subcon flat fee' do
          the_rule.get_entries(event, account).map(&:class).should =~ [PaymentToSubcontractor]
          the_rule.get_entries(event, account).sum(&:amount).should == subcon_flat_fee
        end
      end
      describe 'entries for ScCollectEvent' do

        before do
          job.complete_work
          job.subcon_invoiced_payment
          job.payment_type = 'cash'
          job.collector    = job.subcontractor
          job.subcon_collected_payment
        end

        it 'should create collection entries' do
          the_rule.get_entries(event, account).sum(&:amount).should == subcon_flat_fee
        end

      end


    end

    pending 'for provider account' do
      pending 'a subcon received a job from local subcon'
    end

    describe 'complete job event' do

    end
  end
end