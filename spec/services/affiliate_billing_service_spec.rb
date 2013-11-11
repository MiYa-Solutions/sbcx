require 'spec_helper'

describe 'Affiliate Billing Service' do
  let(:prov) { FactoryGirl.create(:member) }
  let(:subcon) { FactoryGirl.create(:member) }

  describe 'profit_split' do
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
    let(:subcon_job) { Ticket.find_by_ref_id_and_organization_id(job.ref_id, subcon.id) }
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
        Rails.logger.debug { "1. starting before transfer job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
        #Rails.logger.debug {"1. starting before transfer subcon_job: \n subcon_job.status: #{subcon_job.try(:status_name)}, \nsubcon_job.work_status: #{subcon_job.try(:work_status_name)}, \nsubcon_job.billing_status: #{subcon_job.try(:billing_status_name)}, \nsubcon_job.provider_status: #{subcon_job.try(:provider_status_name)}"}
        job.subcontractor    = subcon.becomes(Subcontractor)
        job.subcon_agreement = agreement
        job.transfer
        subcon_job.accept
        subcon_job.start_work
        add_bom_to_ticket subcon_job, 10, 100, 1, prov
        add_bom_to_ticket subcon_job, 20, 200, 1, subcon
        Rails.logger.debug { "1. ending before transfer job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
        Rails.logger.debug { "1. ending before transfer subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

      end
      # subcon cut is the total price minus the material cost + the reimbursement for the part
      let(:subcon_cut) { Money.new_with_amount((300 - 20 - 10)* 0.5 + 20) }
      let(:amount_with_tax) { Money.new_with_amount(300 + (300 * (job.reload.tax / 100.0))) }
      let(:subcon_cut_with_cash) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cash_rate] / 100.0)))* 0.5 + Money.new_with_amount(20) }
      let(:subcon_cut_with_credit) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:credit_rate] / 100.0)))* 0.5 + Money.new_with_amount(20) }
      let(:subcon_cut_with_cheque) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cheque_rate] / 100.0)))* 0.5 + Money.new_with_amount(20) }
      let(:subcon_cut_with_amex) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:amex_rate] / 100.0)))* 0.5 + Money.new_with_amount(20) }

      describe 'with tax' do
        before do
          Rails.logger.debug { "2. starting before 'with tax' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
          Rails.logger.debug { "2. starting before 'with tax' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

          subcon_job.tax = 7.0

          Rails.logger.debug { "2. ending before 'with tax' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.reload.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
          Rails.logger.debug { "2. ending before 'with tax' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

        end

        describe 'after completion' do
          before do
            Rails.logger.debug { "3. starting before 'after completion' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
            Rails.logger.debug { "3. starting before 'after completion' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

            subcon_job.complete_work

            Rails.logger.debug { "3. ending before 'after completion' job: \njob.status: #{job.status_name}, \njob.work_status: #{job.reload.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
            Rails.logger.debug { "3. ending before 'after completion' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

          end

          it 'subcon account should have PaymentToSubcontractor + MaterialReimbursementToCparty entires' do
            subcon_acc.entries.where(ticket_id: job.id).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty]
          end

          it 'subcon balance should be total + tax amount + material cost' do
            subcon_acc.balance.should eq -subcon_cut
          end

          describe 'after cash collection' do
            before do
              Rails.logger.debug { "4. starting before 'after cash collection' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
              Rails.logger.debug { "4. starting before 'after cash collection' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

              subcon_job.invoice_payment
              subcon_job.payment_type = :cash
              subcon_job.collect_payment

              Rails.logger.debug { "4. ending before 'after cash collection' job: \njob.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
              Rails.logger.debug { "4. ending before 'after cash collection' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

            end
            it 'the subcon acc balance should be the total amount minus the subcon cut income' do
              subcon_acc.balance.should eq (amount_with_tax - subcon_cut_with_cash)
            end
            it 'the provider acc balance should be the total amount minus the subcon cut withdrawal' do
              prov_acc.balance.should eq -(amount_with_tax - subcon_cut_with_cash)
            end

            describe 'subcon deposited' do
              before do
                Rails.logger.debug { "5. starting before 'subcon deposited' job: \n job.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                Rails.logger.debug { "5. starting before 'subcon deposited' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

                subcon_job.deposit_to_prov_payment
                job.reload
                job.confirm_deposit_payment

                Rails.logger.debug { "5. ending before 'subcon deposited' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                Rails.logger.debug { "5. ending before 'subcon deposited' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

              end

              it 'subcon account should be the subcon_cut for cash' do
                subcon_acc.balance.should eq -subcon_cut_with_cash
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
                  Rails.logger.debug { "6. starting before 'subcon settled' job: \n job.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                  Rails.logger.debug { "6. starting before 'subcon settled' subcon_job: \n subcon_job.status: #{subcon_job.reload.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

                  subcon_job.provider_payment = :cash
                  subcon_job.settle_provider

                  Rails.logger.debug { "6. ending before 'subcon settled' job: \n job.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                  Rails.logger.debug { "6. ending before 'subcon settled' subcon_job: \n subcon_job.status: #{subcon_job.reload.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

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

    describe 'broker' do
      let(:broker) { FactoryGirl.create(:member) }
      let(:prov_agreement) { setup_profit_split_agreement(prov, broker, 50, payment_terms) }
      let(:subcon_agreement) { setup_profit_split_agreement(broker, subcon, 40, payment_terms) }
      let(:broker_job) { Ticket.find_by_ref_id_and_organization_id(job.ref_id, broker.id) }

      let(:broker_subcon_acc) { Account.for(broker, subcon).first }
      let(:broker_prov_acc) { Account.for(broker, prov).first }
      let(:subcon_broker_acc) { Account.for(subcon, broker).first }
      let(:prov_broker_acc) { Account.for(prov, broker).first }


      let(:subcon_cut) { Money.new_with_amount((300 - 20 - 10)* 0.4 + 30) }
      let(:amount_with_tax) { Money.new_with_amount(300 + (300 * (job.reload.tax / 100.0))) }
      let(:subcon_cut_with_cash) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cash_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }
      let(:subcon_cut_with_credit) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:credit_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }
      let(:subcon_cut_with_cheque) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cheque_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }
      let(:subcon_cut_with_amex) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:amex_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }

      let(:prov_income) { Money.new_with_amount((300 - 20 - 10)* 0.5 + 30) }
      let(:broker_cut_with_cash) { prov_cut_with_cash - subcon_cut_with_cash }
      let(:broker_cut_with_credit) { prov_cut_with_credit - subcon_cut_with_credit }
      let(:broker_cut_with_cheque) { prov_cut_with_cheque - subcon_cut_with_cheque }
      let(:broker_cut_with_amex) { prov_cut_with_amex - subcon_cut_with_amex }

      let(:prov_cut_with_cash) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cash_rate] / 100.0)))* 0.5 }
      let(:prov_cut_with_credit) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:credit_rate] / 100.0)))* 0.5 }
      let(:prov_cut_with_cheque) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cheque_rate] / 100.0)))* 0.5 }
      let(:prov_cut_with_amex) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:amex_rate] / 100.0)))* 0.5 }


      before do
        with_user(prov.users.first) do
          job.subcontractor    = broker.becomes(Subcontractor)
          job.subcon_agreement = prov_agreement
          job.transfer
        end

        with_user(broker.users.first) do
          broker_job.accept

          broker_job.subcontractor    = subcon.becomes(Subcontractor)
          broker_job.subcon_agreement = subcon_agreement
          broker_job.transfer
        end

        with_user(subcon.users.first) do
          subcon_job.accept
          subcon_job.start_work
          add_bom_to_ticket subcon_job, 10, 100, 1, subcon
          add_bom_to_ticket subcon_job, 20, 200, 1, subcon
        end

      end

      describe 'job completed' do

        before do
          with_user(subcon.users.first) do
            subcon_job.tax = 7.0
            subcon_job.complete_work
          end
        end

        it 'subcon account should have PaymentToSubcontractor + MaterialReimbursementToCparty entires' do
          broker_subcon_acc.reload.entries.where(ticket_id: broker_job.id).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty]
          subcon_broker_acc.reload.entries.where(ticket_id: subcon_job.id).map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
        end

        it 'provider account should have IncomeFromProvider + MaterialReimbursementToCparty entires' do
          broker_prov_acc.reload.entries.where(ticket_id: broker_job.id).map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
          prov_broker_acc.reload.entries.where(ticket_id: job.id).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty]
        end


        it 'subcon balance should be total + tax amount + material cost' do
          broker_subcon_acc.reload.balance.should eq -subcon_cut
          subcon_broker_acc.reload.balance.should eq subcon_cut
        end

        it 'provider balance should be total + tax amount + material cost' do
          broker_prov_acc.balance.should eq prov_income
          prov_broker_acc.balance.should eq -prov_income
        end


      end

      pending 'ensure broker billing works well'
    end
  end

  describe 'flat_fee' do
    let(:agreement) { setup_flat_fee_agreement(prov, subcon) }

    let(:job) { FactoryGirl.create(:my_service_call, organization: agreement.organization, subcontractor: nil) }
    let(:subcon_job) { Ticket.find_by_ref_id_and_organization_id(job.ref_id, subcon.id) }
    let(:customer) { job.customer }
    let(:customer_acc) { Account.for(prov, customer).first }
    let(:subcon_acc) { Account.for(prov, subcon).first }
    let(:prov_acc) { Account.for(subcon, prov).first }

    let(:billing_service) { AffiliateBillingService.new(FactoryGirl.create(:service_call_completed_event)) }

    subject { billing_service }

    describe 'transferred job' do
      before do
        Rails.logger.debug { "1. starting before transfer job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
        #Rails.logger.debug {"1. starting before transfer subcon_job: \n subcon_job.status: #{subcon_job.try(:status_name)}, \nsubcon_job.work_status: #{subcon_job.try(:work_status_name)}, \nsubcon_job.billing_status: #{subcon_job.try(:billing_status_name)}, \nsubcon_job.provider_status: #{subcon_job.try(:provider_status_name)}"}
        job.subcontractor    = subcon.becomes(Subcontractor)
        job.subcon_agreement = agreement
        job.transfer
        subcon_job.accept
        subcon_job.start_work
        add_bom_to_ticket subcon_job, 10, 100, 1, prov
        add_bom_to_ticket subcon_job, 20, 200, 1, subcon
        Rails.logger.debug { "1. ending before transfer job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
        Rails.logger.debug { "1. ending before transfer subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

      end
      # subcon cut is the total price minus the material cost + the reimbursement for the part
      let(:subcon_cut) { Money.new_with_amount((300 - 20 - 10)* 0.5 + 20) }
      let(:amount_with_tax) { Money.new_with_amount(300 + (300 * (job.reload.tax / 100.0))) }

      describe 'with tax' do
        before do
          Rails.logger.debug { "2. starting before 'with tax' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
          Rails.logger.debug { "2. starting before 'with tax' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

          subcon_job.tax = 7.0

          Rails.logger.debug { "2. ending before 'with tax' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.reload.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
          Rails.logger.debug { "2. ending before 'with tax' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

        end

        describe 'after completion' do
          before do
            Rails.logger.debug { "3. starting before 'after completion' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
            Rails.logger.debug { "3. starting before 'after completion' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

            subcon_job.complete_work

            Rails.logger.debug { "3. ending before 'after completion' job: \njob.status: #{job.status_name}, \njob.work_status: #{job.reload.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
            Rails.logger.debug { "3. ending before 'after completion' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

          end

          it 'subcon account should have PaymentToSubcontractor + MaterialReimbursementToCparty entires' do
            subcon_acc.entries.where(ticket_id: job.id).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty]
          end

          it 'subcon balance should be total + tax amount + material cost' do
            subcon_acc.balance.should eq -subcon_cut
          end

          describe 'after cash collection' do
            before do
              Rails.logger.debug { "4. starting before 'after cash collection' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
              Rails.logger.debug { "4. starting before 'after cash collection' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

              subcon_job.invoice_payment
              subcon_job.payment_type = :cash
              subcon_job.collect_payment

              Rails.logger.debug { "4. ending before 'after cash collection' job: \njob.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
              Rails.logger.debug { "4. ending before 'after cash collection' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

            end
            it 'the subcon acc balance should be the total amount minus the subcon cut income' do
              subcon_acc.balance.should eq (amount_with_tax - subcon_cut_with_cash)
            end
            it 'the provider acc balance should be the total amount minus the subcon cut withdrawal' do
              prov_acc.balance.should eq -(amount_with_tax - subcon_cut_with_cash)
            end

            describe 'subcon deposited' do
              before do
                Rails.logger.debug { "5. starting before 'subcon deposited' job: \n job.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                Rails.logger.debug { "5. starting before 'subcon deposited' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

                subcon_job.deposit_to_prov_payment
                job.reload
                job.confirm_deposit_payment

                Rails.logger.debug { "5. ending before 'subcon deposited' job: \n job.status: #{job.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                Rails.logger.debug { "5. ending before 'subcon deposited' subcon_job: \n subcon_job.status: #{subcon_job.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

              end

              it 'subcon account should be the subcon_cut for cash' do
                subcon_acc.balance.should eq -subcon_cut_with_cash
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
                  Rails.logger.debug { "6. starting before 'subcon settled' job: \n job.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                  Rails.logger.debug { "6. starting before 'subcon settled' subcon_job: \n subcon_job.status: #{subcon_job.reload.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

                  subcon_job.provider_payment = :cash
                  subcon_job.settle_provider

                  Rails.logger.debug { "6. ending before 'subcon settled' job: \n job.status: #{job.reload.status_name}, \njob.work_status: #{job.work_status_name}, \njob.billing_status: #{job.billing_status_name}, \njob.subcontractor_status: #{job.subcontractor_status_name}" }
                  Rails.logger.debug { "6. ending before 'subcon settled' subcon_job: \n subcon_job.status: #{subcon_job.reload.status_name}, \nsubcon_job.work_status: #{subcon_job.work_status_name}, \nsubcon_job.billing_status: #{subcon_job.billing_status_name}, \nsubcon_job.provider_status: #{subcon_job.provider_status_name}" }

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

    describe 'broker' do
      let(:broker) { FactoryGirl.create(:member) }
      let(:prov_agreement) { setup_profit_split_agreement(prov, broker, 50, payment_terms) }
      let(:subcon_agreement) { setup_profit_split_agreement(broker, subcon, 40, payment_terms) }
      let(:broker_job) { Ticket.find_by_ref_id_and_organization_id(job.ref_id, broker.id) }

      let(:broker_subcon_acc) { Account.for(broker, subcon).first }
      let(:broker_prov_acc) { Account.for(broker, prov).first }
      let(:subcon_broker_acc) { Account.for(subcon, broker).first }
      let(:prov_broker_acc) { Account.for(prov, broker).first }


      let(:subcon_cut) { Money.new_with_amount((300 - 20 - 10)* 0.4 + 30) }
      let(:amount_with_tax) { Money.new_with_amount(300 + (300 * (job.reload.tax / 100.0))) }
      let(:subcon_cut_with_cash) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cash_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }
      let(:subcon_cut_with_credit) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:credit_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }
      let(:subcon_cut_with_cheque) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cheque_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }
      let(:subcon_cut_with_amex) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:amex_rate] / 100.0)))* 0.4 + Money.new_with_amount(30) }

      let(:prov_income) { Money.new_with_amount((300 - 20 - 10)* 0.5 + 30) }
      let(:broker_cut_with_cash) { prov_cut_with_cash - subcon_cut_with_cash }
      let(:broker_cut_with_credit) { prov_cut_with_credit - subcon_cut_with_credit }
      let(:broker_cut_with_cheque) { prov_cut_with_cheque - subcon_cut_with_cheque }
      let(:broker_cut_with_amex) { prov_cut_with_amex - subcon_cut_with_amex }

      let(:prov_cut_with_cash) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cash_rate] / 100.0)))* 0.5 }
      let(:prov_cut_with_credit) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:credit_rate] / 100.0)))* 0.5 }
      let(:prov_cut_with_cheque) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:cheque_rate] / 100.0)))* 0.5 }
      let(:prov_cut_with_amex) { (Money.new_with_amount(300 - 20 - 10) - (amount_with_tax * (payment_terms[:amex_rate] / 100.0)))* 0.5 }


      before do
        with_user(prov.users.first) do
          job.subcontractor    = broker.becomes(Subcontractor)
          job.subcon_agreement = prov_agreement
          job.transfer
        end

        with_user(broker.users.first) do
          broker_job.accept

          broker_job.subcontractor    = subcon.becomes(Subcontractor)
          broker_job.subcon_agreement = subcon_agreement
          broker_job.transfer
        end

        with_user(subcon.users.first) do
          subcon_job.accept
          subcon_job.start_work
          add_bom_to_ticket subcon_job, 10, 100, 1, subcon
          add_bom_to_ticket subcon_job, 20, 200, 1, subcon
        end

      end

      describe 'job completed' do

        before do
          with_user(subcon.users.first) do
            subcon_job.tax = 7.0
            subcon_job.complete_work
          end
        end

        it 'subcon account should have PaymentToSubcontractor + MaterialReimbursementToCparty entires' do
          broker_subcon_acc.reload.entries.where(ticket_id: broker_job.id).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty]
          subcon_broker_acc.reload.entries.where(ticket_id: subcon_job.id).map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
        end

        it 'provider account should have IncomeFromProvider + MaterialReimbursementToCparty entires' do
          broker_prov_acc.reload.entries.where(ticket_id: broker_job.id).map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
          prov_broker_acc.reload.entries.where(ticket_id: job.id).map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty]
        end


        it 'subcon balance should be total + tax amount + material cost' do
          broker_subcon_acc.reload.balance.should eq -subcon_cut
          subcon_broker_acc.reload.balance.should eq subcon_cut
        end

        it 'provider balance should be total + tax amount + material cost' do
          broker_prov_acc.balance.should eq prov_income
          prov_broker_acc.balance.should eq -prov_income
        end


      end

      pending 'ensure broker billing works well'
    end

  end

end