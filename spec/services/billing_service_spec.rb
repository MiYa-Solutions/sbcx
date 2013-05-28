require 'spec_helper'

describe AffiliateBillingService do
  let(:prov) { FactoryGirl.create(:member) }
  let(:subcon) { FactoryGirl.create(:member) }
  let(:payment_terms) do
    { :cash_rate        => 1.0,
      :cheque_rate      => 2.0,
      :credit_rate      => 3.0,
      :cash_rate_type   => :percentage,
      :cheque_rate_type => :percentage,
      :credit_rate_type => :percentage
    }
  end
  let(:agreement) { setup_profit_split_agreement(prov, subcon, 50, payment_terms) }
  let(:job) { FactoryGirl.create(:my_service_call, organization: agreement.organization, subcontractor: nil) }
  let(:customer) { job.customer }
  let(:customer_acc) { Account.for(prov, customer).first }
  let(:subcon_acc) { Account.for(prov, subcon).first }
  let(:prov_acc) { Account.for(subcon, prov).first }

  let(:billing_service) { AffiliateBillingService.new(FactoryGirl.create(:service_call_completed_event)) }

  subject { billing_service }

  describe "methods" do

    [:execute, :find_affiliate_agreements, :find_customer_agreement].each do |method|
      pending
    end

  end

  describe 'job not transferred: ' do

    before do
      add_bom_to_ticket job, 10, 100, 1, prov
      add_bom_to_ticket job, 20, 200, 1, prov
      job.start_work
      job.complete_work
    end
    it 'customer account should have ServiceCallCharge entry' do
      customer_acc.entries.where(ticket_id: job.id).map(&:class).should =~ [ServiceCallCharge]
    end

    it 'service call charge entry should be of the right amount' do
      customer_acc.entries.where(ticket_id: job.id, type: ServiceCallCharge).first.amount.should eq Money.new_with_amount(300)
    end

    it 'the customer account balance should be the correct one' do
      customer.account.balance.should eq Money.new_with_amount(300)
    end

    describe 'cash payment' do
      before do
        job.invoice_payment
        job.payment_type = :cash
        job.paid_payment
      end

      it 'should have a payment entry' do
        payment_entry = job.entries.where(type: CashPayment).first
        job.entries.map(&:class).should =~ [ServiceCallCharge, CashPayment]
        payment_entry.amount.should eq Money.new_with_amount(-300)
        payment_entry.account.should == job.customer.account
        customer.account.balance == Money.new_with_amount(0)
      end
    end

    describe 'amex payment' do
      before do
        job.invoice_payment
        job.payment_type = :amex_credit_card
        job.paid_payment
      end

      it 'should have a payment entry' do
        payment_entry = job.entries.where(type: CashPayment).first
        job.entries.map(&:class).should =~ [ServiceCallCharge, CashPayment]
        payment_entry.amount.should eq Money.new_with_amount(-300)
        payment_entry.account.should == job.customer.account
        customer.account.balance == Money.new_with_amount(0)
      end

    end
  end

end