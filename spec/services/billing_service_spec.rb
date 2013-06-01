require 'spec_helper'

describe 'Billing Service' do
  let(:prov) { FactoryGirl.create(:member) }
  let(:subcon) { FactoryGirl.create(:member) }
  let(:payment_terms) do
    { :cash_rate        => 1.0,
      :cheque_rate      => 2.0,
      :credit_rate      => 3.0,
      :amex_rate        => 4.0,
      :cash_rate_type   => :percentage,
      :amex_rate_type   => :percentage,
      :cheque_rate_type => :percentage,
      :credit_rate_type => :percentage
    }
  end
  let(:agreement) { setup_profit_split_agreement(prov, subcon, 50, payment_terms) }
  let(:job) { FactoryGirl.create(:my_service_call, organization: agreement.organization, subcontractor: nil) }
  let(:subcon_job) { Ticket.find_by_ref_id_and_organization_id(job.ref_id, job.subcontractor_id) }
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
      job.tax = 7.0
      job.start_work
      job.complete_work
    end
    it 'customer account should have ServiceCallCharge entry' do
      customer_acc.entries.where(ticket_id: job.id).map(&:class).should =~ [ServiceCallCharge]
    end

    it 'service call charge entry should be of the right amount' do
      customer_acc.entries.where(ticket_id: job.id, type: ServiceCallCharge).first.amount.should eq Money.new_with_amount(300) + Money.new_with_amount(300) * (job.tax / 100.0)
    end

    it 'the customer account balance should be the correct one' do
      customer.account.balance.should eq Money.new_with_amount(300)+ Money.new_with_amount(300) * (job.tax / 100.0)
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
        payment_entry.amount.should eq -(Money.new_with_amount(300)+ Money.new_with_amount(300) * (job.tax / 100.0))
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
        payment_entry = job.entries.where(type: AmexPayment).first
        job.entries.map(&:class).should =~ [ServiceCallCharge, AmexPayment]
        payment_entry.amount.should eq -(Money.new_with_amount(300) + Money.new_with_amount(300) * (job.tax / 100.0))
        payment_entry.account.should == job.customer.account
        customer.account.balance == Money.new_with_amount(0)
      end

    end
  end

  describe 'transferred job' do
    before do
      job.subcontractor    = subcon.becomes(Subcontractor)
      job.subcon_agreement = agreement
      job.transfer
      subcon_job.accept
      subcon_job.start_work
      add_bom_to_ticket subcon_job, 10, 100, 1, prov
      add_bom_to_ticket subcon_job, 20, 200, 1, subcon
    end
    # subcon cut is the tota price minus the material cost + the reimbursement for the part
    let(:subcon_cut) { Money.new_with_amount((300 - 20 - 10)* 0.5 + 20) }
    let(:amount_with_tax) { Money.new_with_amount(300 + (300 * (job.reload.tax / 100.0))) }
    let(:subcon_cut_with_cash) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cash_rate] / 100.0)))* 0.5 + Money.new_with_amount(20)  }
    let(:subcon_cut_with_credit) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:credit_rate] / 100.0)))* 0.5 + Money.new_with_amount(20) }
    let(:subcon_cut_with_cheque) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cheque_rate] / 100.0)))* 0.5 + Money.new_with_amount(20) }
    let(:subcon_cut_with_amex) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:amex_rate] / 100.0)))* 0.5 + Money.new_with_amount(20) }

    describe 'with tax' do
      before do
        subcon_job.tax = 7.0
      end

      describe 'after completion' do
        before do
          subcon_job.complete_work
        end

        it 'subcon account should have PaymentToSubcontractor + MaterialReimbursementToCparty entires' do
          subcon_acc.entries.where(ticket_id: job.id).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty]
        end

        it 'subcon balance should be total + tax amount + material cost' do
          subcon_acc.balance.should eq -subcon_cut
        end

        describe 'after cash collection' do
          before do
            subcon_job.invoice_payment
            subcon_job.payment_type = :cash
            subcon_job.collect_payment
          end
          it 'the subcon acc balance should be the total amount minus the subcon cut income' do
            subcon_acc.balance.should eq (amount_with_tax - subcon_cut_with_cash)
          end
          it 'the provider acc balance should be the total amount minus the subcon cut withdrawal' do
            prov_acc.balance.should eq -(amount_with_tax - subcon_cut_with_cash)
          end

          describe 'subcon deposited' do
            before do
              subcon_job.deposit_to_prov_payment
              job.reload.confirm_deposit_payment
            end

            it 'subcon account should be the subcon_cut for cash' do
              subcon_acc.balance.should eq  -subcon_cut_with_cash
            end

            describe 'provider settled' do
              before do
                job.subcon_payment = :cash
                job.settle_subcon
              end

              it 'subcon account should be set to zero' do
                subcon_acc.balance.should eq Money.new_with_amount(0)
              end

              it 'provider account should be set to zero' do
                prov_acc.balance.should eq Money.new_with_amount(0)
              end

            end
            describe 'subcon settled' do
              before do
                subcon_job.provider_payment = :cash
                subcon_job.settle_provider
              end

              it 'subcon account should be set to zero' do
                subcon_acc.balance.should eq Money.new_with_amount(0)
              end

              it 'provider account should be set to zero' do
                prov_acc.balance.should eq Money.new_with_amount(0)
              end

            end
          end

        end

        describe 'after credit collection' do
          before do
            subcon_job.invoice_payment
            subcon_job.payment_type = :credit_card
            subcon_job.collect_payment
          end
          it 'the subcon acc balance should be the total amount minus the subcon cut income' do
            subcon_acc.balance.should eq (amount_with_tax - subcon_cut_with_credit)
          end
          it 'the provider acc balance should be the total amount minus the subcon cut withdrawal' do
            prov_acc.balance.should eq -(amount_with_tax - subcon_cut_with_credit)
          end

        end

        describe 'after amex collection' do
          before do
            subcon_job.invoice_payment
            subcon_job.payment_type = :amex_credit_card
            subcon_job.collect_payment
          end
          it 'the subcon acc balance should be the total amount minus the subcon cut income' do
            subcon_acc.balance.should eq (amount_with_tax - subcon_cut_with_amex)
          end
          it 'the provider acc balance should be the total amount minus the subcon cut withdrawal' do
            prov_acc.balance.should eq -(amount_with_tax - subcon_cut_with_amex)
          end

        end

        describe 'after cheque collection' do
          before do
            subcon_job.invoice_payment
            subcon_job.payment_type = :cheque
            subcon_job.collect_payment
          end
          it 'the subcon acc balance should be the total amount minus the subcon cut income' do
            subcon_acc.balance.should eq (amount_with_tax - subcon_cut_with_cheque)
          end
          it 'the provider acc balance should be the total amount minus the subcon cut withdrawal' do
            prov_acc.balance.should eq -(amount_with_tax - subcon_cut_with_cheque)
          end

        end
      end


    end


  end

end