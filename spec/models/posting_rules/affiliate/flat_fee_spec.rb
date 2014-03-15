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

describe FlatFee do

  let(:rule) { FlatFee.new }
  subject { rule }

  it 'should have only na as the option' do
    rule.rate_types.should == [:na]
  end

  it 'should have a bom_reimbursement? method' do
    should respond_to :bom_reimbursement?
  end

  describe 'get account entries methods' do

    # data needed for the below tests
    let(:org) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]).organization }
    let(:subcon) { setup_flat_fee_agreement(org, FactoryGirl.create(:subcontractor)).counterparty }
    let(:account) { Account.for_affiliate(org, subcon).first }
    let(:agreement) { Agreement.our_agreements(org, subcon.becomes(Organization)).first }
    let(:the_rule) { agreement.rules.first }
    let(:job) { FactoryGirl.create(:my_service_call, organization: org, subcontractor: nil) }

    let(:bom1_cost) { 53.49 }
    let(:bom1_price) { 153 }
    let(:bom1_qty) { 2 }

    let(:bom2_cost) { 0.49 }
    let(:bom2_price) { 0.75 }
    let(:bom2_qty) { 1 }
    let(:subcon_flat_fee) { Money.new_with_amount(10) }
    let(:event) { job.events.first }

    before do
      job.subcon_agreement = agreement
      job.subcontractor    = subcon.becomes(Subcontractor)
      job.properties       = (job.properties || {}).merge('subcon_fee' => subcon_flat_fee)
      job.transfer
      job.accept_work

      job.start_work

      add_bom_to_ticket(job, bom1_cost, bom1_price, bom1_qty, job.organization)
      add_bom_to_ticket(job, bom2_cost, bom2_price, bom2_qty, job.subcontractor.becomes(Organization))

    end

    describe '#get_transfer_props' do

      let(:props) { rule.get_transfer_props }

      it 'props should be of type TransferProperties' do
        props.should be_kind_of(TicketProperties)
      end

      it 'should have bom_reimbursement column' do
        props.should respond_to(:bom_reimbursement)
      end

      it 'should have monetized subcon_fee method with a default of zero' do
        props.should respond_to(:subcon_fee)
        #props.should monetize(:subcon_fee)
        expect(props).to monetize(:subcon_fee)
        #props.subcon_fee.should == Money.new_with_amount(0)
      end

      it 'should load the ticket properties after transfer' do
        the_rule.get_transfer_props(job).subcon_fee == Money.new_with_amount(10)
      end

    end


    describe '#org_charge_entries' do
      describe 'without bom reimbursement' do
        before do
          job.complete_work
        end

        it 'entries should be [PaymentToSubcontractor] and sub to the preset subcon cut' do
          the_rule.get_entries(event, account).map(&:class).should =~ [PaymentToSubcontractor]
          the_rule.get_entries(event, account).sum(&:amount).should == subcon_flat_fee
          account.balance.should == -subcon_flat_fee
        end
      end
      describe 'with bom reimbursement' do
        before do
          job.properties = (job.properties || {}).merge('bom_reimbursement' => true)
          job.complete_work
        end

        it 'entries should be [PaymentToSubcontractor] and sub to the preset subcon cut' do
          the_rule.get_entries(event, account).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty]
          the_rule.get_entries(event, account).sum(&:amount).should == subcon_flat_fee + Money.new_with_dollars(bom2_cost*bom2_qty)
          account.balance.should == -subcon_flat_fee - Money.new_with_dollars(bom2_cost*bom2_qty)
        end
      end

    end

    describe '#org_collection_entries' do
      before do
        job.complete_work
        job.subcon_invoiced_payment
        job.payment_type = 'cheque'
        job.collector    = job.subcontractor.becomes(Organization)
        job.subcon_collected_payment
      end

      it 'the event associated should be ScProviderCollectedEvent' do
        event.should be_instance_of(ScCollectedEvent)
      end

      it 'entries should be [ChequeCollectionFromSubcon] and sum to the job total price' do
        the_rule.get_entries(event, account).map(&:class).should =~ [ChequeCollectionFromSubcon]
        the_rule.get_entries(event, account).sum(&:amount).should == job.total_price
        account.balance.should == -subcon_flat_fee + job.total_price
      end


    end

    describe '#org_settlement_entries' do

      before do
        job.complete_work
        job.subcon_invoiced_payment
        job.payment_type = 'cheque'
        job.collector    = job.subcontractor.becomes(Organization)
        job.subcon_collected_payment
        job.subcon_payment = 'cheque'
        job.settle_subcon
      end

      it 'the event associated should be ScProviderCollectedEvent' do
        event.should be_instance_of(ScSubconSettleEvent)
      end

      it 'entries should be [ChequeCollectionFromSubcon] and sum to the job total price' do
        the_rule.get_entries(event, account).map(&:class).should =~ [ChequePaymentToAffiliate]
        the_rule.get_entries(event, account).sum(&:amount).should == subcon_flat_fee
        account.balance.should == job.total_price
      end

    end


    describe '#cparty_collection_entries' do

    end

    describe '#counterparty_entries' do

    end
    describe '#counterparty_entries' do

    end
  end


  describe '#get_entries' do
    let(:bom1_cost) { 53.49 }
    let(:bom1_price) { 153 }
    let(:bom1_qty) { 2 }

    let(:bom2_cost) { 0.49 }
    let(:bom2_price) { 0.75 }
    let(:bom2_qty) { 1 }
    let(:total_price) { Money.new_with_amount(bom1_price*bom1_qty + bom2_price*bom2_qty) }
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


    #let(:rule) { org.agreements.where(counterparty_id: org2.id).first.posting_rules.first }

    describe 'for local subcon account' do
      let(:org) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]).organization }
      let(:subcon) { setup_flat_fee_agreement(org, FactoryGirl.create(:subcontractor)).counterparty }
      let(:account) { Account.for_affiliate(org, subcon).first }
      let(:agreement) { Agreement.our_agreements(org, subcon.becomes(Organization)).first }
      let(:the_rule) { agreement.rules.first }
      let(:job) { FactoryGirl.create(:my_service_call, organization: org, subcontractor: nil) }
      let(:event) { job.events.first }

      before do
        job.subcon_agreement = agreement
        job.subcontractor    = subcon.becomes(Subcontractor)
        #job.subcon_fee       = subcon_flat_fee
        job.properties       = (job.properties || {}).merge('subcon_fee' => subcon_flat_fee)
        job.transfer
        job.accept_work

        job.start_work

        add_bom_to_ticket(job, bom1_cost, bom1_price, bom1_qty, job.organization)
        add_bom_to_ticket(job, bom2_cost, bom2_price, bom2_qty, job.organization)

        job.complete_work

      end
      describe 'entries for CompleteEvent' do

        it 'one entry for the subcon account with the subcon flat fee' do
          the_rule.get_entries(event, account).map(&:class).should =~ [PaymentToSubcontractor]
          the_rule.get_entries(event, account).sum(&:amount).should == subcon_flat_fee
        end
      end
      describe 'entries for ScCollectEvent' do

        before do
          job.subcon_invoiced_payment
          job.payment_type = 'cash'
          job.collector    = job.subcontractor
          job.subcon_collected_payment
        end

        it 'should create collection entries' do
          the_rule.get_entries(event, account).map(&:class).should =~ [CashCollectionFromSubcon]
          the_rule.get_entries(event, account).sum(&:amount).should == total_price
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
