require 'spec_helper'


describe "Account Pages", js: true do
  self.use_transactional_fixtures = false

  setup_standard_orgs

  let(:job) { create_my_job(org_admin_user, customer, :org) }
  let(:profit_split) { Agreement.our_agreements(org, org2).first.rules.first }

  let(:bom1) {
    params                = { name: "material1", price: 59.99, cost: 13.67, quantity: 1 }
    params[:total_cost]   = params[:cost] * params[:quantity]          # expected to be 13.67
    params[:total_price]  = params[:price] * params[:quantity]         # expeceted to be 119.98
    params[:total_profit] = params[:total_price] - params[:total_cost] # expected to be 106.31
    params
  }
  let(:bom2) {
    params                = { name: "material2", price: 100, cost: 10, quantity: 2 }
    params[:total_cost]   = params[:cost] * params[:quantity]          # expected to be 20
    params[:total_price]  = params[:price] * params[:quantity]         # expected to be 200
    params[:total_profit] = params[:total_price] - params[:total_cost] # expected to be 180
    params

  }

  let(:expected_price) { bom1[:total_price] + bom2[:total_price] }
  let(:expected_subcon_cut) { (bom1[:total_profit] + bom2[:total_profit])*(profit_split.rate / 100.0) + bom1[:total_cost] + bom2[:total_cost] }
  let(:org1_org2_acc) { Account.for_affiliate(org, org2).first }
  let(:org2_org1_acc) { Account.for_affiliate(org2, org).first }
  let(:customer_acc) { Account.for_customer(job.customer).first }

  before do
    in_browser(:org) do
      sign_in org_admin_user
    end

    in_browser(:org2) do
      sign_in org_admin_user2
    end
  end

  subject { page }

  # todo create correction ability using account entries controller
  # todo add collected_by to the payment event
  # todo add a proposal ticket type
  # todo add beneficiary for cheque payment upon completion
  # todo create the fixed price rule


  describe 'none transferred service call' do
    before do
      in_browser(:org) do
        visit service_call_path(job)
        click_button JOB_BTN_START
        add_bom bom1[:name], bom1[:cost], bom1[:price], bom1[:quantity]
        add_bom bom2[:name], bom2[:cost], bom2[:price], bom2[:quantity]
      end
    end

    describe 'when completed' do
      before do
        click_button JOB_BTN_COMPLETE
        visit customer_path customer
      end
      it 'the customer account should be updated with the amount' do

        should have_customer_balance(expected_price)
      end

      it 'the customer account should show accounting entry' do
        entries = job.reload.entries.where(type: ServiceCallCharge)
        entries.should have(1).entry
        should have_entry(entries.first, amount: expected_price, type: ServiceCallCharge.model_name.human)
        should have_customer_balance(expected_price)
      end

      describe 'when invoiced' do
        before do
          visit service_call_path(job)
          click_button JOB_BTN_INVOICE
        end

        it "should send an invoice to the customer"

        describe 'when paid' do

          describe 'with cash payment' do
            before do
              select Cash.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            it 'clear button is NOT shown' do
              should_not have_button(I18n.t('activerecord.state_machines.my_service_call.billing_status.events.clear'))
            end


            it 'customer account should show the payment and zero balance' do
              entries = customer_acc.entries.where(type: CashPayment, ticket_id: job.id)
              entries.all.should have(1).entry

              visit customer_path customer
              should have_entry(entries.first, amount: -job.total_price, type: CashPayment.model_name.human, status: 'cleared')
              should have_customer_balance(0)
            end

          end

          describe 'with credit card payment' do
            before do
              select CreditCard.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            it 'clear button is shown' do
              should have_button(I18n.t('activerecord.state_machines.my_service_call.billing_status.events.clear'))
            end

            it 'customer account should show the payment and zero balance' do
              entries = customer_acc.entries.where(type: CreditPayment, ticket_id: job.id)
              entries.all.should have(1).entry

              visit customer_path customer
              should have_entry(entries.first, amount: -job.total_price, type: CreditPayment.model_name.human, status: 'pending')
              should have_customer_balance(0)
            end

            describe 'clearing payment' do
              before do
                click_button JOB_BTN_CLEAR
              end

              it 'job billing and accounting entries statuses should change to cleared' do
                should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.cleared'))

                entries = customer_acc.entries.where(type: CreditPayment, ticket_id: job.id)
                entries.all.should have(1).entry

                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: CreditPayment.model_name.human, status: 'cleared')
              end
            end

          end

          describe 'with cheque payment' do
            before do
              select Cheque.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            it 'clear button is shown' do
              should have_button(I18n.t('activerecord.state_machines.my_service_call.billing_status.events.clear'))
            end

            it 'customer account should show the payment and zero balance' do
              entries = customer_acc.entries.where(type: ChequePayment, ticket_id: job.id)
              entries.all.should have(1).entry

              visit customer_path customer
              should have_entry(entries.first, amount: -job.total_price, type: ChequePayment.model_name.human, status: 'pending')
              should have_customer_balance(0)
            end

            describe 'clearing payment' do
              before do
                click_button JOB_BTN_CLEAR
              end

              it 'billing and accounting entries statuses should change to cleared' do
                should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.cleared'))

                entries = customer_acc.entries.where(type: ChequePayment, ticket_id: job.id)
                entries.all.should have(1).entry

                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: ChequePayment.model_name.human, status: 'cleared')
              end
            end
          end
        end
      end


    end

  end

  describe 'transferred service call to a member subcon' do
    let(:subcon_job) { Ticket.last }
    before do
      in_browser(:org) do
        visit service_call_path(job)
        select org2.name, from: JOB_SELECT_SUBCONTRACTOR
        check JOB_CBOX_RE_TRANSFER
        check JOB_CBOX_ALLOW_COLLECTION
        click_button JOB_BTN_TRANSFER
      end

      in_browser(:org2) do
        visit service_call_path(subcon_job)
        click_button JOB_BTN_ACCEPT
        click_button JOB_BTN_START
        add_bom bom1[:name], bom1[:cost], bom1[:price], bom1[:quantity]
        add_bom bom2[:name], bom2[:cost], bom2[:price], bom2[:quantity]
      end

    end
    describe 'with profit share' do
      describe 'when completed' do
        before do
          in_browser(:org2) do
            click_button JOB_BTN_COMPLETE
          end
        end

        it 'customers account should show the correct balance' do
          in_browser(:org) do
            visit customer_path customer
            should have_customer_balance(expected_price)
          end

        end

        it 'provider view should show a payment to subcon entry (withdrawal)' do
          job.reload
          org1_org2_acc.entries.map(&:class).should include(PaymentToSubcontractor)
          accounting_entry      = org1_org2_acc.entries.scoped.where(type: 'PaymentToSubcontractor', ticket_id: job.id).first
          expected_entry_amount = (job.total_profit * accounting_entry.amount_direction) * (profit_split.rate / 100.0)

          in_browser(:org) do
            visit affiliate_path org2

            should have_entry(accounting_entry, amount: expected_entry_amount)
          end

        end

        it 'provider view should show reimbursement for the parts' do
          org1_org2_acc.entries.map(&:class).should include(MaterialReimbursementToCparty)
          entries = org1_org2_acc.entries.where(type: MaterialReimbursementToCparty)
          entries.all.should have(2).entries

          in_browser(:org) do
            visit affiliate_path org2
            entries.each do |entry|
              should have_entry(entry, amount: entry.amount)
            end

          end
        end

        it 'provider view should show the correct balance' do
          job.reload
          expected_balance = -(job.total_profit * (profit_split.rate / 100.0) + job.total_cost)
          in_browser(:org) do
            visit affiliate_path org2
            should have_affiliate_balance(expected_balance)
          end

        end

        it 'subcontractor view should show a payment from provider entry (income)' do
          subcon_job.reload
          accounting_entry = org2_org1_acc.entries.scoped.where(type: 'IncomeFromProvider', ticket_id: subcon_job.id).first
          expected_amount  = (subcon_job.total_profit * accounting_entry.amount_direction) * (profit_split.rate / 100.0)
          in_browser(:org2) do
            visit affiliate_path org
            should have_entry(accounting_entry, amount: expected_amount)
          end

        end

        it 'subcontractor view should show reimbursement for the parts' do
          org2_org1_acc.entries.map(&:class).should include(MaterialReimbursement)
          entries = org2_org1_acc.entries.where(type: MaterialReimbursement)
          entries.all.should have(2).entries

          in_browser(:org2) do
            visit affiliate_path org
            entries.each do |entry|
              should have_entry(entry, amount: entry.amount)
            end

          end

        end

        it 'subcontractor view should show the correct balance' do
          in_browser(:org2) do
            expected_balance = (subcon_job.total_profit * (profit_split.rate / 100.0) + subcon_job.total_cost)
            visit affiliate_path org
            should have_affiliate_balance(expected_balance)
          end

        end

        it "technician's view should show an employee commission (income)"

        describe 'when invoiced by subcontractor' do
          before do
            in_browser(:org2) do
              visit service_call_path(subcon_job)
              click_button JOB_BTN_INVOICE
            end
          end

          it 'should show a select of payment type with a collect button' do
            should have_select JOB_SELECT_PAYMENT
            should have_button JOB_BTN_COLLECT
          end

          it "should send an invoice to the customer"

          describe 'with cash payment' do
            before do
              in_browser(:org2) do
                select Cash.model_name.human, from: JOB_SELECT_PAYMENT
                click_button JOB_BTN_COLLECT
              end
            end


            it 'customer account should show cash payment entry' do
              entries = customer_acc.entries.where(type: CashPayment, ticket_id: job.id)
              entries.all.should have(1).entry

              in_browser(:org) do
                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: CashPayment.model_name.human)
              end
            end

            it 'customer account should be zero' do
              in_browser(:org) do
                visit customer_path customer
                should have_customer_balance 0
              end
            end

            it 'provider view: account should show cash collection entry from subcontractor with a cleared status (income)' do
              entries = org1_org2_acc.entries.where(type: CashCollectionFromSubcon, ticket_id: job.id)
              entries.all.should have(1).entry
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_entry(entries.first, amount: job.total_price, status: 'cleared', type: CashCollectionFromSubcon.model_name.human)
              end

            end

            it 'provider view: account balance should be set to the difference between the total price and cost' do
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_affiliate_balance((subcon_job.total_price - subcon_job.total_cost)*(1 - profit_split.rate/100.0))
              end

            end

            it 'subcontractor view: account should show cash collection entry for provider with cleared status (withdrawal)' do
              entries = org2_org1_acc.entries.where(type: CashCollectionForProvider, ticket_id: subcon_job.id)
              entries.all.should have(1).entry
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_entry(entries.first, amount: -subcon_job.total_price, status: 'cleared', type: CashCollectionForProvider.model_name.human)
              end

            end

            it 'subcontractor view: account balance should be set to the difference between the total price and cost' do
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_affiliate_balance(-(job.total_price - job.total_cost)*(1 - profit_split.rate/100.0))
              end

            end

            it "technician's account should show cash collection for employer with pending status (withdrawal)"

            describe 'when the payment is marked as deposited by the subcontractor' do

              before do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  click_button JOB_BTN_DEPOSIT
                end
              end
              it 'subcon view: account should show the entry as deposited and the balance is updated' do
                entries = org2_org1_acc.entries.where(type: CashDepositToProvider, ticket_id: subcon_job.id)

                in_browser(:org2) do
                  visit affiliate_path(subcon_job.provider)
                  should have_entry(entries.first, status: 'deposited', type: CashDepositToProvider.model_name.human)
                  should have_affiliate_balance((job.total_price - job.total_cost)*(profit_split.rate/100.0) + job.total_cost)
                end

              end

              it 'provider view: account should show the entry as deposited and balance is updated' do
                entries = org1_org2_acc.entries.where(type: CashDepositFromSubcon, ticket_id: job.id)
                entries.all.should have(1).entry
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)
                  should have_entry(entries.first, amount: -job.total_price, status: 'deposited', type: CashDepositFromSubcon.model_name.human)
                  should have_affiliate_balance(-((job.total_price - job.total_cost)*(profit_split.rate/100.0) + job.total_cost))
                end

              end

              it "technician's account should show the entry as deposited"
              it "technician's account should now have the amount type as income"

              describe 'when provider confirms the deposit ' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_BTN_CONFIRM_DEPOSIT
                  end

                end
                it 'subcon view: account should show the entry as cleared' do
                  entries = org2_org1_acc.entries.where(type: CashDepositToProvider, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.provider)
                    should have_entry(entries.first, status: 'cleared')
                  end
                end
                it 'provider view: account should should the entry as cleared' do
                  entries = org1_org2_acc.entries.where(type: CashDepositFromSubcon, ticket_id: job.id)
                  entries.should have(1).entry
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)
                    should have_entry(entries.first, status: 'cleared')
                  end

                end
                it "technician's account should show the entry as cleared"
              end
            end

          end
          describe 'with credit card payment' do
            before do
              in_browser(:org2) do
                select CreditCard.model_name.human, from: JOB_SELECT_PAYMENT
                click_button JOB_BTN_COLLECT
              end
            end


            it 'customer account should show credit card payment entry' do
              entries = customer_acc.entries.where(type: CreditPayment, ticket_id: job.id)
              entries.all.should have(1).entry

              in_browser(:org) do
                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: CreditPayment.model_name.human)
              end
            end

            it 'customer account should be zero' do
              in_browser(:org) do
                visit customer_path customer
                should have_customer_balance 0
              end
            end

            it 'provider view: account should show credit card collection from subcon with a cleared status (income)' do
              entries = org1_org2_acc.entries.where(type: CreditCardCollectionFromSubcon, ticket_id: job.id)
              entries.all.should have(1).entry
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_entry(entries.first, amount: job.total_price, status: 'cleared', type: CreditCardCollectionFromSubcon.model_name.human)
              end
            end

            it 'provider view: account balance should be set to the difference between the total price and cost' do
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_affiliate_balance((subcon_job.total_price - subcon_job.total_cost)*(1 - profit_split.rate/100.0))
              end
            end

            it 'subcon view: account should show credit card collection for provider with cleared status (withdrawal)' do
              entries = org2_org1_acc.entries.where(type: CreditCardCollectionForProvider, ticket_id: subcon_job.id)
              entries.all.should have(1).entry
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_entry(entries.first, amount: -subcon_job.total_price, status: 'cleared', type: CreditCardCollectionForProvider.model_name.human)
              end
            end

            it 'subcon view: account balance should be set to the difference between the total price and cost' do
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_affiliate_balance(-(job.total_price - job.total_cost)*(1 - profit_split.rate/100.0))
              end
            end

            it "technician's account should not have additional entries"

            describe 'when marked as deposited by the subcontractor' do

              before do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  click_button JOB_BTN_DEPOSIT
                end
              end
              it 'subcon view: account should show the entry as deposited and the balance is updated' do
                entries = org2_org1_acc.entries.where(type: CreditCardDepositToProvider, ticket_id: subcon_job.id)

                in_browser(:org2) do
                  visit affiliate_path(subcon_job.provider)
                  should have_entry(entries.first, status: 'deposited', type: CreditCardDepositToProvider.model_name.human)
                  should have_affiliate_balance((job.total_price - job.total_cost)*(profit_split.rate/100.0) + job.total_cost)
                end

              end

              it 'provider view: account should show the entry as deposited and balance is updated' do
                entries = org1_org2_acc.entries.where(type: CreditCardDepositFromSubcon, ticket_id: job.id)
                entries.all.should have(1).entry
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)
                  should have_entry(entries.first, amount: -job.total_price, status: 'deposited', type: CreditCardDepositFromSubcon.model_name.human)
                  should have_affiliate_balance(-((job.total_price - job.total_cost)*(profit_split.rate/100.0) + job.total_cost))
                end

              end

              it "technician's account should show the entry as deposited"
              it "technician's account should now have the amount type as income"

              describe 'when provider confirms the deposit ' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_BTN_CONFIRM_DEPOSIT
                  end

                end
                it 'subcon view: account should show the entry as cleared' do
                  entries = org2_org1_acc.entries.where(type: CreditCardDepositToProvider, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.provider)
                    should have_entry(entries.first, status: 'cleared')
                  end
                end
                it 'provider view: account should show the entry as cleared' do
                  entries = org1_org2_acc.entries.where(type: CreditCardDepositFromSubcon, ticket_id: job.id)
                  entries.should have(1).entry
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)
                    should have_entry(entries.first, status: 'cleared')
                  end

                end
                it "subcontractor's account should show the entry as cleared"
                it "technician's account should show the entry as cleared"
              end
            end

          end
          describe 'with cheque payment' do
            before do
              in_browser(:org2) do
                select Cheque.model_name.human, from: JOB_SELECT_PAYMENT
                click_button JOB_BTN_COLLECT
              end
            end


            it 'customer account should show cheque payment entry with pending status' do
              entries = customer_acc.entries.where(type: ChequePayment, ticket_id: job.id)
              entries.all.should have(1).entry

              in_browser(:org) do
                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: ChequePayment.model_name.human, status: 'pending')
              end
            end

            it 'provider view: account should show cheque collection from subcontractor with a cleared status (income)' do
              entries = org1_org2_acc.entries.where(type: ChequeCollectionFromSubcon, ticket_id: job.id)
              entries.all.should have(1).entry
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_entry(entries.first, amount: job.total_price, status: 'cleared', type: ChequeCollectionFromSubcon.model_name.human)
              end
            end

            it 'provider view: account balance should be set to the difference between the total price and cost' do
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_affiliate_balance((subcon_job.total_price - subcon_job.total_cost)*(1 - profit_split.rate/100.0))
              end
            end

            it 'subcon view: account should show cheque collection to provider with pending status (withdrawal)' do
              entries = org2_org1_acc.entries.where(type: ChequeCollectionForProvider, ticket_id: subcon_job.id)
              entries.all.should have(1).entry
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_entry(entries.first, amount: -subcon_job.total_price, status: 'cleared', type: ChequeCollectionForProvider.model_name.human)
              end
            end

            it 'subcon view: account balance should be set to the difference between the total price and cost' do
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_affiliate_balance(-(job.total_price - job.total_cost)*(1 - profit_split.rate/100.0))
              end
            end


            it "technician's account should show pending check collection for employer withdrawal"

            describe 'when the cheque is marked as deposited by the subcontractor' do

              before do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  click_button JOB_BTN_DEPOSIT
                end
              end
              it 'subcon view: account should show the entry as deposited and the balance is updated' do
                entries = org2_org1_acc.entries.where(type: ChequeDepositToProvider, ticket_id: subcon_job.id)

                in_browser(:org2) do
                  visit affiliate_path(subcon_job.provider)
                  should have_entry(entries.first, status: 'deposited', type: ChequeDepositToProvider.model_name.human)
                  should have_affiliate_balance((job.total_price - job.total_cost)*(profit_split.rate/100.0) + job.total_cost)
                end

              end

              it 'provider view: account should show the entry as deposited and balance is updated' do
                entries = org1_org2_acc.entries.where(type: ChequeDepositFromSubcon, ticket_id: job.id)
                entries.all.should have(1).entry
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)
                  should have_entry(entries.first, amount: -job.total_price, status: 'deposited', type: ChequeDepositFromSubcon.model_name.human)
                  should have_affiliate_balance(-((job.total_price - job.total_cost)*(profit_split.rate/100.0) + job.total_cost))
                end

              end

              it "technician's account should show the entry as deposited"
              it "technician's account should now have the amount type as income"

              describe 'when provider confirms the deposit ' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_BTN_CONFIRM_DEPOSIT
                  end

                end
                it 'subcon view: account should show the entry as cleared' do
                  entries = org2_org1_acc.entries.where(type: ChequeDepositToProvider, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.provider)
                    should have_entry(entries.first, status: 'cleared')
                  end
                end
                it 'provider view: account should should the entry as cleared' do
                  entries = org1_org2_acc.entries.where(type: ChequeDepositFromSubcon, ticket_id: job.id)
                  entries.should have(1).entry
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)
                    should have_entry(entries.first, status: 'cleared')
                  end

                end
                it "subcontractor's account should show the entry as cleared"
                it "technician's account should show the entry as cleared"
              end
            end


          end

        end

        describe 'when invoiced by provider' do
          before do
            in_browser(:org) do
              visit service_call_path(job)
              click_button JOB_BTN_INVOICE
            end
          end

          it 'should show a select of payment type with a paid button' do
            should have_select JOB_SELECT_PAYMENT
            should have_button JOB_BTN_PAID
          end

          it "should send an invoice to the customer"

          describe 'with cash payment' do
            before do
              select Cash.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            it 'customer account should show cash payment entry' do
              entry = job.accounting_entries.where("type = 'CashPayment'").last
              visit customer_path customer
              should have_entry(entry, amount: -job.total_price, type: CashPayment.model_name.human)

            end

            it 'customer account should be zero' do
              visit customer_path customer
              should have_customer_balance 0
            end

            it 'provider view: account should not have any additional entries' do
              job.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ServiceCallCharge, CashPayment]
              org1_org2_acc.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty]
              customer_acc.entries.reload.map(&:class).should =~ [ServiceCallCharge, CashPayment]
            end

            it 'subcon view: account should not have any additional entries' do
              subcon_job.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
              org2_org1_acc.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
            end

            it "technician's account should show cash collection for employer with pending status (withdrawal)"
          end
          describe 'with credit card payment' do
            before do
              select CreditCard.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            it 'customer account should show pending credit card payment entry with zero balance ' do
              entry = job.accounting_entries.where(type: CreditPayment).last
              visit customer_path customer
              should have_entry(entry, amount: -job.total_price, type: CreditPayment.model_name.human, status: 'pending')

            end

            it 'provider view: account should not have any additional entries' do
              job.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ServiceCallCharge, CreditPayment]
              org1_org2_acc.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty]
              customer_acc.entries.reload.map(&:class).should =~ [ServiceCallCharge, CreditPayment]
            end

            it 'subcon view: account should not have any additional entries' do
              subcon_job.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
              org2_org1_acc.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
            end

            it "technician's account should not have additional entries"

            describe 'clearing payment' do
              before do
                click_button JOB_BTN_CLEAR
              end

              it 'job billing and accounting entries statuses should change to cleared' do
                should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.cleared'))

                entries = customer_acc.entries.where(type: CreditPayment, ticket_id: job.id)
                entries.all.should have(1).entry

                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: CreditPayment.model_name.human, status: 'cleared')
              end
            end

          end
          describe "with cheque payment" do
            before do
              select Cheque.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            describe "when collected by the technician" do
              it 'customer account should show pending credit card payment entry with zero balance ' do
                entry = job.accounting_entries.where(type: ChequePayment).last
                visit customer_path customer
                should have_entry(entry, amount: -job.total_price, type: ChequePayment.model_name.human, status: 'pending')

              end

              it 'provider view: account should not have any additional entries' do
                job.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ServiceCallCharge, ChequePayment]
                org1_org2_acc.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty]
                customer_acc.entries.reload.map(&:class).should =~ [ServiceCallCharge, ChequePayment]
              end

              it 'subcon view: account should not have any additional entries' do
                subcon_job.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
                org2_org1_acc.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement]
              end

              it "technician's account should show pending check collection for employer withdrawal"

              describe 'clearing payment' do
                before do
                  click_button JOB_BTN_CLEAR
                end

                it 'job billing and accounting entries statuses should change to cleared' do
                  should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.cleared'))

                  entries = customer_acc.entries.where(type: ChequePayment, ticket_id: job.id)
                  entries.all.should have(1).entry

                  visit customer_path customer
                  should have_entry(entries.first, amount: -job.total_price, type: ChequePayment.model_name.human, status: 'cleared')
                end
              end

            end


          end

        end

        describe 'provider / subcon settlement' do
          before do
            in_browser(:org) do
              visit service_call_path(job)
              click_button JOB_BTN_INVOICE
              select Cheque.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
              click_button JOB_BTN_CLEAR
            end

          end

          it 'provider view: settlement button and subcon payment select should be available' do
            in_browser(:org) do
              visit service_call_path(job)
              should have_select JOB_SELECT_SUBCON_PAYMENT
              should have_button JOB_BTN_SETTLE
            end
          end

          it 'subcon view: settlement button and provider payment should be available' do
            in_browser(:org2) do
              visit service_call_path(subcon_job)
              should have_select JOB_SELECT_PROVIDER_PAYMENT
              should have_button JOB_BTN_SETTLE

            end
          end

          it 'provider view: should not allow settlement without choosing a payment' do
            in_browser(:org) do
              visit service_call_path(job)
              click_button JOB_BTN_SETTLE
              should have_selector 'div.alert-error'
            end
          end

          it 'subcon view: should not allow settlement without choosing a payment' do
            in_browser(:org2) do
              visit service_call_path(subcon_job)
              click_button JOB_BTN_SETTLE
              should have_selector 'div.alert-error'
            end
          end

          describe 'provider indicates the job is settled ' do

            describe 'with cash' do

              before do
                in_browser(:org) do
                  select Cash.model_name.human, from: JOB_SELECT_SUBCON_PAYMENT
                  click_button JOB_BTN_SETTLE
                end
              end


              it 'subcon view: should send a notification to the subcon' do
                in_browser(:org2) do
                  visit user_root_path
                  should have_text(I18n.t('notifications.sc_provider_settled_notification.subject', ref: subcon_job.ref_id))
                end
              end

              it 'provider view: status should be set to Settled?' do
                in_browser(:org) do
                  should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                end
              end

              it 'subcon view: status should be set to marked as settled by prov' do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claimed_as_settled'))
                end
              end

              it 'provider view: account should have a cash payment entry with deposited status' do
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)

                  entries = org1_org2_acc.entries.where(type: CashPaymentToAffiliate, ticket_id: job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: expected_subcon_cut, type: CashPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CashPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut, type: CashPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'subcon confirms the settlement' do
                before do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    click_button JOB_CONFIRM_SETTLEMENT
                  end

                end
                it 'subcon view: status should change to settled' do
                  in_browser(:org2) do
                    should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.settled'))
                  end
                end

                it 'provider view: status should change to settled' do
                  in_browser(:org) do
                    visit service_call_path(job)
                    should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                    should_not have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                  end

                end

                it 'provider should get a notification' do
                  in_browser(:org) do
                    visit user_root_path
                    job.reload
                    should have_text(I18n.t('notifications.sc_subcon_confirmed_settled_notification.subject', subcon: job.subcontractor.name, ref: job.ref_id))
                  end
                end

                it 'provider view: payment entry status should change to cleared' do
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)

                    entries = job.entries.where(type: CashPaymentToAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CashPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end

                end
              end
            end
            describe 'with credit card' do
              before do
                in_browser(:org) do
                  select CreditCard.model_name.human, from: JOB_SELECT_SUBCON_PAYMENT
                  click_button JOB_BTN_SETTLE
                end
              end

              it 'subcon view: should send a notification to the subcon' do
                in_browser(:org2) do
                  visit user_root_path
                  should have_text(I18n.t('notifications.sc_provider_settled_notification.subject', ref: subcon_job.ref_id))
                end
              end

              it 'provider view: status should be set to Settled?' do
                in_browser(:org) do
                  should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                end
              end

              it 'subcon view: status should be set to marked as settled by prov' do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claimed_as_settled'))
                end
              end

              it 'provider view: account should have a credit payment entry with deposited status' do
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)

                  entries = org1_org2_acc.entries.where(type: CreditPaymentToAffiliate, ticket_id: job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: expected_subcon_cut, type: CreditPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CreditPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut, type: CreditPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'subcon confirms the settlement' do
                before do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    click_button JOB_CONFIRM_SETTLEMENT
                  end

                end
                it 'subcon view: status should change to settled' do
                  in_browser(:org2) do
                    should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.settled'))
                  end
                end

                it 'provider view: status should change to settled' do
                  in_browser(:org) do
                    visit service_call_path(job)
                    should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                    should_not have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                  end

                end

                it 'provider should get a notification' do
                  in_browser(:org) do
                    visit user_root_path
                    job.reload
                    should have_text(I18n.t('notifications.sc_subcon_confirmed_settled_notification.subject', subcon: job.subcontractor.name, ref: job.ref_id))
                  end
                end

                it 'provider view: payment entry status should change to cleared' do
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)

                    entries = job.entries.where(type: CreditPaymentToAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CreditPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end

                end
              end

            end
            describe 'with cheque' do
              before do
                in_browser(:org) do
                  select Cheque.model_name.human, from: JOB_SELECT_SUBCON_PAYMENT
                  click_button JOB_BTN_SETTLE
                end
              end

              it 'subcon view: should send a notification to the subcon' do
                in_browser(:org2) do
                  visit user_root_path
                  should have_text(I18n.t('notifications.sc_provider_settled_notification.subject', ref: subcon_job.ref_id))
                end
              end

              it 'provider view: status should be set to Settled?' do
                in_browser(:org) do
                  should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                end
              end

              it 'subcon view: status should be set to marked as settled by prov' do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claimed_as_settled'))
                end
              end

              it 'provider view: account should have a credit payment entry with deposited status' do
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)

                  entries = org1_org2_acc.entries.where(type: ChequePaymentToAffiliate, ticket_id: job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: expected_subcon_cut, type: ChequePaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: ChequePaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut, type: ChequePaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'subcon confirms the settlement' do
                before do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    click_button JOB_CONFIRM_SETTLEMENT
                  end

                end

                it 'subcon view: status should change to settled' do
                  in_browser(:org2) do
                    should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.settled'))
                  end
                end

                it 'provider view: status should change to settled' do
                  in_browser(:org) do
                    visit service_call_path(job)
                    should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                    should_not have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                  end

                end

                it 'provider should get a notification' do
                  in_browser(:org) do
                    visit user_root_path
                    job.reload
                    should have_text(I18n.t('notifications.sc_subcon_confirmed_settled_notification.subject', subcon: job.subcontractor.name, ref: job.ref_id))
                  end
                end

                it 'provider view: payment entry status should change to cleared' do
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)

                    entries = job.entries.where(type: ChequePaymentToAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: ChequePaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end

                end
              end
            end
          end
          describe 'subcon indicates the job is settled ' do

            describe 'with cash' do

              before do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  select Cash.model_name.human, from: JOB_SELECT_PROVIDER_PAYMENT
                  click_button JOB_BTN_SETTLE
                end
              end


              it 'provider view: should send a notification to the subcon' do
                in_browser(:org) do
                  visit user_root_path
                  should have_text(I18n.t('notifications.sc_settled_notification.subject', ref: job.ref_id))
                end
              end

              it 'subcontractor view: status should be set to Settled?' do
                in_browser(:org2) do
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                end
              end

              it 'provider view: status should be set to marked as settled by subcon' do
                in_browser(:org) do
                  visit service_call_path(job)
                  should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claimed_as_settled'))
                end
              end

              it 'provider view: account should have a cash payment entry with deposited status' do
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)

                  entries = org1_org2_acc.entries.where(type: CashPaymentToAffiliate, ticket_id: job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: expected_subcon_cut, type: CashPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CashPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut, type: CashPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'provider confirms the settlement' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_CONFIRM_SETTLEMENT
                  end

                end
                it 'provider view: status should change to settled' do
                  in_browser(:org) do
                    should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                  end
                end

                it 'subcon view: status should change to settled' do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.settled'))
                    should_not have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                  end

                end

                it 'subcon should get a notification' do
                  in_browser(:org2) do
                    visit user_root_path
                    job.reload
                    should have_text(I18n.t('notifications.sc_provider_confirmed_settled_notification.subject', ref: job.ref_id))
                  end
                end

                it 'provider view: payment entry status should change to cleared' do
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)

                    entries = job.entries.where(type: CashPaymentToAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CashPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end

                end
              end
            end
            describe 'with credit card' do
              before do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  select CreditCard.model_name.human, from: JOB_SELECT_PROVIDER_PAYMENT
                  click_button JOB_BTN_SETTLE
                end
              end

              it 'provider view: should have a notification ' do
                in_browser(:org) do
                  visit user_root_path
                  should have_text(I18n.t('notifications.sc_settled_notification.subject', ref: job.ref_id))
                end
              end

              it 'subcon view: status should be set to Settled?' do
                in_browser(:org2) do
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                end
              end

              it 'subcon view: status should be set to marked as settled by provider' do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                end
              end

              it 'provider view: account should have a credit payment entry with deposited status' do
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)

                  entries = org1_org2_acc.entries.where(type: CreditPaymentToAffiliate, ticket_id: job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: expected_subcon_cut, type: CreditPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CreditPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut, type: CreditPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'provider confirms the settlement' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_CONFIRM_SETTLEMENT
                  end

                end
                it 'subcon view: status should change to settled' do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.settled'))
                    should_not have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                  end
                end

                it 'provider view: status should change to settled' do
                  in_browser(:org) do
                    visit service_call_path(job)
                    should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                    should_not have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                  end

                end

                it 'subcon should get a notification' do
                  in_browser(:org2) do
                    visit user_root_path
                    subcon_job.reload
                    should have_text(I18n.t('notifications.sc_provider_confirmed_settled_notification.subject', ref: job.ref_id))
                  end
                end

                it 'provider view: payment entry status should change to cleared' do
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)

                    entries = job.entries.where(type: CreditPaymentToAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CreditPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end

                end
              end

            end
            describe 'with cheque' do
              before do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  select Cheque.model_name.human, from: JOB_SELECT_PROVIDER_PAYMENT
                  click_button JOB_BTN_SETTLE
                end
              end

              it 'provider view: should have a notification ' do
                in_browser(:org) do
                  visit user_root_path
                  should have_text(I18n.t('notifications.sc_settled_notification.subject', ref: job.ref_id))
                end
              end

              it 'subcon view: status should be set to Settled?' do
                in_browser(:org2) do
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                end
              end

              it 'subcon view: status should be set to marked as settled by provider' do
                in_browser(:org2) do
                  visit service_call_path(subcon_job)
                  should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                end
              end

              it 'provider view: account should have a credit payment entry with deposited status' do
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)

                  entries = org1_org2_acc.entries.where(type: ChequePaymentToAffiliate, ticket_id: job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: expected_subcon_cut, type: ChequePaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: ChequePaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut, type: ChequePaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'provider confirms the settlement' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_CONFIRM_SETTLEMENT
                  end

                end
                it 'subcon view: status should change to settled' do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.settled'))
                    should_not have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                  end
                end

                it 'provider view: status should change to settled' do
                  in_browser(:org) do
                    visit service_call_path(job)
                    should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                    should_not have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                  end

                end

                it 'subcon should get a notification' do
                  in_browser(:org2) do
                    visit user_root_path
                    subcon_job.reload
                    should have_text(I18n.t('notifications.sc_provider_confirmed_settled_notification.subject', ref: job.ref_id))
                  end
                end

                it 'provider view: payment entry status should change to cleared' do
                  in_browser(:org) do
                    visit affiliate_path(job.reload.subcontractor)

                    entries = job.entries.where(type: ChequePaymentToAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: ChequePaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut)
                    should have_affiliate_balance(0)

                  end

                end
              end

            end
          end

        end
      end
    end


  end


end

