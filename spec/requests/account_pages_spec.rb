require 'spec_helper'


describe "Account Pages", js: true do
  self.use_transactional_fixtures = false

  setup_standard_orgs

  let(:job) { create_my_job(org_admin_user, customer, :org) }
  let(:profit_split) { Agreement.our_agreements(org, org2).first.rules.first }

  let(:bom1) {
    params                = { name: "material1", price: 100.00, cost: 10.00, quantity: 1 }
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

  let(:boms_cost) { bom1[:total_cost] + bom2[:total_cost] }
  let(:expected_price) { Money.new_with_amount(bom1[:total_price] + bom2[:total_price]) }
  let(:expected_subcon_cut) { (bom1[:total_profit] + bom2[:total_profit])*(profit_split.rate / 100.0) + bom1[:total_cost] + bom2[:total_cost] }
  let(:cash_fee) do
    case profit_split.cash_rate_type
      when 'percentage'
        expected_price * (profit_split.cash_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(profit_split.cash_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end
  end
  let(:credit_fee) do
    case profit_split.credit_rate_type
      when 'percentage'
        expected_price * (profit_split.credit_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(profit_split.credit_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end

  end
  let(:amex_fee) do
    case profit_split.amex_rate_type
      when 'percentage'
        expected_price * (profit_split.amex_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(profit_split.amex_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end

  end
  let(:cheque_fee) do
    case profit_split.cheque_rate_type
      when 'percentage'
        expected_price * (profit_split.cheque_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(profit_split.cheque_rate.delete(',').to_f)
      else
        Money.new_with_amount(0)
    end

  end

  let(:expected_subcon_cut_cash) {
    net = Money.new_with_amount(bom1[:total_profit] + bom2[:total_profit]) - cash_fee
    Money.new_with_amount(boms_cost + (net.to_f * profit_split.rate / 100.0))
  }
  let(:expected_subcon_cut_credit) {
    net = Money.new_with_amount(bom1[:total_profit] + bom2[:total_profit]) - credit_fee
    Money.new_with_amount(boms_cost + (net.to_f * profit_split.rate / 100.0))
  }
  let(:expected_subcon_cut_amex) {
    net = Money.new_with_amount(bom1[:total_profit] + bom2[:total_profit]) - amex_fee
    Money.new_with_amount(boms_cost + (net.to_f * profit_split.rate / 100.0))
  }
  let(:expected_subcon_cut_cheque) {
    net = Money.new_with_amount(bom1[:total_profit] + bom2[:total_profit]) - cheque_fee
    Money.new_with_amount(boms_cost + (net.to_f * profit_split.rate / 100.0))
  }


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

    describe 'cancel' do
      before do
        click_button JOB_BTN_CANCEL
      end

      it 'should not create any accounting entries' do
        expect {}.to_not change(AccountingEntry, :count)
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

      describe 'cancel the job' do
        before do
          visit service_call_path(job)
          click_button JOB_BTN_CANCEL
        end

        describe 'customer account' do
          before do
            visit accounting_entries_path('accounting_entry[account_id]' => customer.account)
            click_button ACC_BTN_GET_ENTRIES
          end

          it 'should show canceled job entry with a zero balance' do
            entries = job.reload.entries.where(type: CanceledJobAdjustment)
            entries.should have(1).entry
            should have_entry(entries.first, amount: -expected_price, type: CanceledJobAdjustment.model_name.human)
            should have_customer_balance(0)

          end

        end

      end


      describe 'when invoiced' do
        before do
          visit service_call_path(job)
          click_button JOB_BTN_INVOICE
        end

        it "should send an invoice to the customer"

        describe 'cancel the job' do
          before do
            visit service_call_path(job)
            click_button JOB_BTN_CANCEL
          end

          describe 'customer account' do
            before do
              visit accounting_entries_path('accounting_entry[account_id]' => customer.account)
              click_button ACC_BTN_GET_ENTRIES
            end

            it 'should show canceled job entry with a zero balance' do
              entries = job.reload.entries.where(type: CanceledJobAdjustment)
              entries.should have(1).entry
              should have_entry(entries.first, amount: -expected_price, type: CanceledJobAdjustment.model_name.human)
              should have_customer_balance(0)

            end

          end

        end


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

            describe 'cancel the job: ' do
              before do
                visit service_call_path(job)
                click_button JOB_BTN_CANCEL
              end

              describe 'customer account: ' do
                before do
                  visit accounting_entries_path('accounting_entry[account_id]' => customer.account)
                  click_button ACC_BTN_GET_ENTRIES
                end

                it 'should show canceled job entry with a zero balance' do
                  entries = job.reload.entries.where(type: CanceledJobAdjustment)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_price, type: CanceledJobAdjustment.model_name.human)
                  should have_customer_balance(-expected_price)

                end

              end

            end


            describe 'adding adjustment entry to customer' do
              before do
                visit accounting_entries_path
                select customer.name, from: ACC_SELECT
                click_button ACC_BTN_GET_ENTRIES
              end

              it 'accounting entries index should show two entries for the customer and zero balance ' do
                payment_entry = customer_acc.entries.where(type: CashPayment, ticket_id: job.id)
                payment_entry.all.should have(1).entry

                service_entry = job.reload.entries.where(type: ServiceCallCharge)
                service_entry.should have(1).entry

                should have_entry(payment_entry.first, amount: -job.total_price, type: CashPayment.model_name.human, status: 'cleared')
                should have_entry(service_entry.first, amount: job.total_price, type: ServiceCallCharge.model_name.human, status: 'cleared')
                should have_customer_balance(0)
              end


              describe 'add positive adjustment customer account' do

                before do
                  click_button ENTRY_BTN_NEW

                end


              end

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

            describe 'cancel the job: ' do
              before do
                visit service_call_path(job)
                click_button JOB_BTN_CANCEL
              end

              describe 'customer account: ' do
                before do
                  visit accounting_entries_path('accounting_entry[account_id]' => customer.account)
                  click_button ACC_BTN_GET_ENTRIES
                end

                it 'should show canceled job entry with a zero balance' do
                  entries = job.reload.entries.where(type: CanceledJobAdjustment)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_price, type: CanceledJobAdjustment.model_name.human)
                  should have_customer_balance(-expected_price)

                end

              end

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

          describe 'with amex payment' do
            before do
              select AmexCreditCard.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            it 'clear button is shown' do
              should have_button(I18n.t('activerecord.state_machines.my_service_call.billing_status.events.clear'))
            end

            it 'customer account should show the payment and zero balance' do
              entries = customer_acc.entries.where(type: AmexPayment, ticket_id: job.id)
              entries.all.should have(1).entry

              visit customer_path customer
              should have_entry(entries.first, amount: -job.total_price, type: AmexPayment.model_name.human, status: 'pending')
              should have_customer_balance(0)
            end

            describe 'cancel the job: ' do
              before do
                visit service_call_path(job)
                click_button JOB_BTN_CANCEL
              end

              describe 'customer account: ' do
                before do
                  visit accounting_entries_path('accounting_entry[account_id]' => customer.account)
                  click_button ACC_BTN_GET_ENTRIES
                end

                it 'should show canceled job entry with a zero balance' do
                  entries = job.reload.entries.where(type: CanceledJobAdjustment)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_price, type: CanceledJobAdjustment.model_name.human)
                  should have_customer_balance(-expected_price)

                end

              end

            end


            describe 'clearing payment' do
              before do
                click_button JOB_BTN_CLEAR
              end

              it 'job billing and accounting entries statuses should change to cleared' do
                should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.cleared'))

                entries = customer_acc.entries.where(type: AmexPayment, ticket_id: job.id)
                entries.all.should have(1).entry

                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: AmexPayment.model_name.human, status: 'cleared')
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

            describe 'cancel the job: ' do
              before do
                visit service_call_path(job)
                click_button JOB_BTN_CANCEL
              end

              describe 'customer account: ' do
                before do
                  visit accounting_entries_path('accounting_entry[account_id]' => customer.account)
                  click_button ACC_BTN_GET_ENTRIES
                end

                it 'should show canceled job entry with a zero balance' do
                  entries = job.reload.entries.where(type: CanceledJobAdjustment)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_price, type: CanceledJobAdjustment.model_name.human)
                  should have_customer_balance(-expected_price)

                end

              end

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
        transfer_job(job, org2)
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
                should have_affiliate_balance(job.total_price - ((job.total_price - job.total_cost - cash_fee)*(profit_split.rate/100.0)+job.total_cost))
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

            it 'subcontractor view: account balance should be set to the difference between the total price and cost considering payment processing fees as cost' do
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_affiliate_balance(-(expected_price - expected_subcon_cut_cash))
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
                  #should have_affiliate_balance((job.total_price - job.total_cost - cash_fee)*(profit_split.rate/100.0) + job.total_cost)
                  should have_affiliate_balance(expected_subcon_cut_cash)
                end

              end

              it 'provider view: account should show the entry as deposited and balance is updated' do
                entries = org1_org2_acc.entries.where(type: CashDepositFromSubcon, ticket_id: job.id)
                entries.all.should have(1).entry
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)
                  should have_entry(entries.first, amount: -job.total_price, status: 'deposited', type: CashDepositFromSubcon.model_name.human)
                  should have_affiliate_balance(-((job.total_price - job.total_cost - cash_fee)*(profit_split.rate/100.0) + job.total_cost))
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

            it 'provider view: account balance should be set to the difference between the total price and costs' do
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_affiliate_balance(job.total_price - ((subcon_job.total_price - subcon_job.total_cost - credit_fee)*(profit_split.rate/100.0) + subcon_job.total_cost))
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
                should have_affiliate_balance(-(job.total_price - expected_subcon_cut_credit))
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
                  should have_affiliate_balance(expected_subcon_cut_credit)
                end

              end

              it 'provider view: account should show the entry as deposited and balance is updated' do
                entries = org1_org2_acc.entries.where(type: CreditCardDepositFromSubcon, ticket_id: job.id)
                entries.all.should have(1).entry
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)
                  should have_entry(entries.first, amount: -job.total_price, status: 'deposited', type: CreditCardDepositFromSubcon.model_name.human)
                  should have_affiliate_balance(-(expected_subcon_cut_credit))
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
          describe 'with amex payment' do
            before do
              in_browser(:org2) do
                select AmexCreditCard.model_name.human, from: JOB_SELECT_PAYMENT
                click_button JOB_BTN_COLLECT
              end
            end


            it 'customer account should show credit card payment entry' do
              entries = customer_acc.entries.where(type: AmexPayment, ticket_id: job.id)
              entries.all.should have(1).entry

              in_browser(:org) do
                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: AmexPayment.model_name.human)
              end
            end

            it 'customer account should be zero' do
              in_browser(:org) do
                visit customer_path customer
                should have_customer_balance 0
              end
            end

            it 'provider view: account should show credit card collection from subcon with a cleared status (income)' do
              entries = org1_org2_acc.entries.where(type: AmexCollectionFromSubcon, ticket_id: job.id)
              entries.all.should have(1).entry
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_entry(entries.first, amount: job.total_price, status: 'cleared', type: AmexCollectionFromSubcon.model_name.human)
              end
            end

            it 'provider view: account balance should be set to the difference between the total price and costs' do
              in_browser(:org) do
                visit affiliate_path(job.reload.subcontractor)
                should have_affiliate_balance(job.total_price - ((subcon_job.total_price - subcon_job.total_cost - amex_fee)*(profit_split.rate/100.0) + subcon_job.total_cost))
              end
            end

            it 'subcon view: account should show credit card collection for provider with cleared status (withdrawal)' do
              entries = org2_org1_acc.entries.where(type: AmexCollectionForProvider, ticket_id: subcon_job.id)
              entries.all.should have(1).entry
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_entry(entries.first, amount: -subcon_job.total_price, status: 'cleared', type: AmexCollectionForProvider.model_name.human)
              end
            end

            it 'subcon view: account balance should be set to the difference between the total price and cost' do
              in_browser(:org2) do
                visit affiliate_path(subcon_job.reload.provider)
                should have_affiliate_balance(-(job.total_price - expected_subcon_cut_amex))
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
                entries = org2_org1_acc.entries.where(type: AmexDepositToProvider, ticket_id: subcon_job.id)

                in_browser(:org2) do
                  visit affiliate_path(subcon_job.provider)
                  should have_entry(entries.first, status: 'deposited', type: AmexDepositToProvider.model_name.human)
                  should have_affiliate_balance(expected_subcon_cut_amex)
                end

              end

              it 'provider view: account should show the entry as deposited and balance is updated' do
                entries = org1_org2_acc.entries.where(type: AmexDepositFromSubcon, ticket_id: job.id)
                entries.all.should have(1).entry
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)
                  should have_entry(entries.first, amount: -job.total_price, status: 'deposited', type: AmexDepositFromSubcon.model_name.human)
                  should have_affiliate_balance(-(expected_subcon_cut_amex))
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
                  entries = org2_org1_acc.entries.where(type: AmexDepositToProvider, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.provider)
                    should have_entry(entries.first, status: 'cleared')
                  end
                end
                it 'provider view: account should show the entry as cleared' do
                  entries = org1_org2_acc.entries.where(type: AmexDepositFromSubcon, ticket_id: job.id)
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
                should have_affiliate_balance((subcon_job.total_price - subcon_job.total_cost - cheque_fee)*(1 - profit_split.rate/100.0) +  cheque_fee)
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
                should have_affiliate_balance(-(job.total_price - expected_subcon_cut_cheque))
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
                  should have_affiliate_balance(expected_subcon_cut_cheque)
                end

              end

              it 'provider view: account should show the entry as deposited and balance is updated' do
                entries = org1_org2_acc.entries.where(type: ChequeDepositFromSubcon, ticket_id: job.id)
                entries.all.should have(1).entry
                in_browser(:org) do
                  visit affiliate_path(job.reload.subcontractor)
                  should have_entry(entries.first, amount: -job.total_price, status: 'deposited', type: ChequeDepositFromSubcon.model_name.human)
                  should have_affiliate_balance(-expected_subcon_cut_cheque)
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
              job.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ServiceCallCharge, CashPayment, ReimbursementForCashPayment]
              org1_org2_acc.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ReimbursementForCashPayment]
              customer_acc.entries.reload.map(&:class).should =~ [ServiceCallCharge, CashPayment]
            end

            it 'subcon view: account should show additional CashPayment entry' do
              subcon_job.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, CashPaymentFee]
              org2_org1_acc.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, CashPaymentFee]
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
              job.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ServiceCallCharge, CreditPayment, ReimbursementForCreditPayment]
              org1_org2_acc.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ReimbursementForCreditPayment]
              customer_acc.entries.reload.map(&:class).should =~ [ServiceCallCharge, CreditPayment]
            end

            it 'subcon view: account should additional CreditPaymentFee entry ' do
              subcon_job.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, CreditPaymentFee]
              org2_org1_acc.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, CreditPaymentFee]
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
          describe 'with amex payment' do
            before do
              select AmexCreditCard.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_PAID
            end

            it 'customer account should show pending credit card payment entry with zero balance ' do
              entry = job.accounting_entries.where(type: AmexPayment).last
              visit customer_path customer
              should have_entry(entry, amount: -job.total_price, type: AmexPayment.model_name.human, status: 'pending')

            end

            it 'provider view: account should not have any additional entries' do
              job.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ServiceCallCharge, AmexPayment, ReimbursementForAmexPayment]
              org1_org2_acc.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ReimbursementForAmexPayment]
              customer_acc.entries.reload.map(&:class).should =~ [ServiceCallCharge, AmexPayment]
            end

            it 'subcon view: account should additional CreditPaymentFee entry ' do
              subcon_job.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, AmexPaymentFee]
              org2_org1_acc.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, AmexPaymentFee]
            end

            it "technician's account should not have additional entries"

            describe 'clearing payment' do
              before do
                click_button JOB_BTN_CLEAR
              end

              it 'job billing and accounting entries statuses should change to cleared' do
                should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.cleared'))

                entries = customer_acc.entries.where(type: AmexPayment, ticket_id: job.id)
                entries.all.should have(1).entry

                visit customer_path customer
                should have_entry(entries.first, amount: -job.total_price, type: AmexPayment.model_name.human, status: 'cleared')
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
                job.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ServiceCallCharge, ChequePayment, ReimbursementForChequePayment]
                org1_org2_acc.entries.reload.map(&:class).should =~ [PaymentToSubcontractor, MaterialReimbursementToCparty, MaterialReimbursementToCparty, ReimbursementForChequePayment]
                customer_acc.entries.reload.map(&:class).should =~ [ServiceCallCharge, ChequePayment]
              end

              it 'subcon view: account should not have any additional entries' do
                subcon_job.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, ChequePaymentFee]
                org2_org1_acc.entries.reload.map(&:class).should =~ [IncomeFromProvider, MaterialReimbursement, MaterialReimbursement, ChequePaymentFee]
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

                it 'should show the clearing event associated with the job' do
                  job.events.pluck(:reference_id).should include(100034)
                  should have_selector('table#event_log_in_service_call td', text: I18n.t('service_call_clear_customer_payment_event.name'))

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

          it 'subcon view: should show cheque payment fee' do
            entry = subcon_job.entries.where(type: ChequePaymentFee)
            entry.should have(1).entries
            #visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(subcon, provider).first.id)
            #should have_entry()
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
                  should have_entry(entries.first, amount: expected_subcon_cut_cheque, type: CashPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CashPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut_cheque , type: CashPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'subcon confirms the settlement' do
                before do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    click_button JOB_BTN_CONFIRM_PROV_SETTLEMENT
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
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut_cheque)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CashPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut_cheque)
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
                  should have_entry(entries.first, amount: Money.new_with_amount(expected_subcon_cut) - cheque_fee*(profit_split.rate / 100.0), type: CreditPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CreditPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: CreditPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'subcon confirms the settlement' do
                before do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    click_button JOB_BTN_CONFIRM_PROV_SETTLEMENT
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
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut_cheque)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CreditPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut_cheque)
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
                  should have_entry(entries.first, amount: expected_subcon_cut_cheque, type: ChequePaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: ChequePaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: ChequePaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'subcon confirms the settlement' do
                before do
                  in_browser(:org2) do
                    visit service_call_path(subcon_job)
                    click_button JOB_BTN_CONFIRM_PROV_SETTLEMENT
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
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut_cheque)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: ChequePaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut_cheque)
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
                  should have_entry(entries.first, amount: expected_subcon_cut_cheque, type: CashPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CashPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: CashPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'provider confirms the settlement' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_BTN_CONFIRM_SETTLEMENT
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
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut_cheque)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CashPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut_cheque)
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
                  should have_entry(entries.first, amount: expected_subcon_cut_cheque, type: CreditPaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: CreditPaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: CreditPaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'provider confirms the settlement' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_BTN_CONFIRM_SETTLEMENT
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
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut_cheque)
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: CreditPaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut_cheque)
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
                  should have_entry(entries.first, amount: expected_subcon_cut_cheque, type: ChequePaymentToAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                in_browser(:org2) do
                  visit affiliate_path(subcon_job.reload.provider)

                  entries = org2_org1_acc.entries.where(type: ChequePaymentFromAffiliate, ticket_id: subcon_job.id)
                  entries.should have(1).entry
                  should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: ChequePaymentFromAffiliate.model_name.human, status: 'deposited')
                  should have_affiliate_balance(0)

                end

              end

              describe 'provider confirms the settlement' do
                before do
                  in_browser(:org) do
                    visit service_call_path(job)
                    click_button JOB_BTN_CONFIRM_SETTLEMENT
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
                    should have_entry(entries.first, status: 'cleared', amount: expected_subcon_cut_cheque )
                    should have_affiliate_balance(0)

                  end
                end

                it 'subcon view: payment entry status should change to cleared' do
                  in_browser(:org2) do
                    visit affiliate_path(subcon_job.reload.provider)

                    entries = subcon_job.entries.where(type: ChequePaymentFromAffiliate)
                    entries.should have(1).entry
                    should have_entry(entries.first, status: 'cleared', amount: -expected_subcon_cut_cheque)
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

  describe 'transferred service call from a local provider' do
    let(:provider) { setup_profit_split_agreement(FactoryGirl.create(:provider), org).organization }
    let(:transferred_job) { create_transferred_job(org_admin_user, provider, :org) }
    let(:provider_org_acc) { Account.for_affiliate(org, provider).first }

    before do
      in_browser(:org) do
        visit service_call_path(transferred_job)
        click_button JOB_BTN_ACCEPT
        click_button JOB_BTN_START
        add_bom bom1[:name], bom1[:cost], bom1[:price], bom1[:quantity]
        add_bom bom2[:name], bom2[:cost], bom2[:price], bom2[:quantity]
      end
    end

    describe 'with profit share' do
      describe 'when completed' do
        before do
          click_button JOB_BTN_COMPLETE
        end

        it 'customer should not have account'

        it 'subcontractor view should show a payment from provider entry (income)' do
          transferred_job.reload
          accounting_entry = provider_org_acc.entries.scoped.where(type: 'IncomeFromProvider', ticket_id: transferred_job.id).first
          expected_amount  = (transferred_job.total_profit * accounting_entry.amount_direction) * (profit_split.rate / 100.0)

          visit affiliate_path provider
          should have_entry(accounting_entry, amount: expected_amount)


        end

        it 'subcontractor view should show reimbursement for the parts and the correct balance' do
          provider_org_acc.entries.map(&:class).should include(MaterialReimbursement)
          entries = provider_org_acc.entries.where(type: MaterialReimbursement)
          entries.all.should have(2).entries

          visit affiliate_path provider
          entries.each do |entry|
            should have_entry(entry, amount: entry.amount)
          end

          expected_balance = (transferred_job.total_profit * (profit_split.rate / 100.0) + transferred_job.total_cost)

          should have_affiliate_balance(expected_balance)

        end

        it 'canceling the job should create one accounting entry for the affiliate' do
          expect do
            click_button JOB_BTN_CANCEL
          end.to change(AccountingEntry, :count).by(1)
        end

        describe 'cancel the job: ' do
          before do
            click_button JOB_BTN_CANCEL
          end


          it 'trying to visit customer account should show no entries and not have the customer available ' do
            visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
            click_button ACC_BTN_GET_ENTRIES

            entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
            entries.should have(0).entry
            should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

          end

          describe 'affiliate account' do
            before do
              visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
              click_button ACC_BTN_GET_ENTRIES
            end

            it 'subcon view: should show  entry and a balance of zero' do
              transferred_job.reload
              accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
              expected_amount  = -(transferred_job.total_profit * accounting_entry.amount_direction) * (profit_split.rate / 100.0)

              should have_entry(accounting_entry, amount: expected_amount)
              should have_affiliate_balance(bom1[:total_cost] + bom2[:total_cost])

            end

          end


        end

        it "technician's view should show an employee commission (income)"

        describe 'when invoiced by subcontractor' do
          before do
            visit service_call_path(transferred_job)
            click_button JOB_BTN_INVOICE
          end

          it 'should show a select of payment type with a collect button' do
            should have_select JOB_SELECT_PAYMENT
            should have_button JOB_BTN_COLLECT
          end

          it "should send an invoice to the customer"

          it 'canceling the job should create one accounting entry for the affiliate' do
            expect do
              click_button JOB_BTN_CANCEL
            end.to change(AccountingEntry, :count).by(1)
          end

          describe 'cancel the job: ' do
            before do
              click_button JOB_BTN_CANCEL
            end


            it 'trying to visit customer account should show no entries and not have the customer available ' do
              visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
              click_button ACC_BTN_GET_ENTRIES

              entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
              entries.should have(0).entry
              should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

            end

            describe 'affiliate account' do
              before do
                visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                click_button ACC_BTN_GET_ENTRIES
              end

              it 'subcon view: should show  entry and a balance of zero' do
                transferred_job.reload
                accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                expected_amount  = -(transferred_job.total_profit * accounting_entry.amount_direction) * (profit_split.rate / 100.0)

                should have_entry(accounting_entry, amount: expected_amount)
                should have_affiliate_balance(bom1[:total_cost] + bom2[:total_cost])

              end

            end


          end

          describe 'with cash payment' do
            before do
              select Cash.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_COLLECT
            end

            it 'subcontractor view: account should show cash collection fee entry for provider with cleared status (withdrawal)' do
              entries = provider_org_acc.entries.where(type: CashCollectionForProvider, ticket_id: transferred_job.id)
              entries.all.should have(1).entry

              cash_entry = provider_org_acc.entries.scoped.where(type: CashPaymentFee, ticket_id: transferred_job.id)
              cash_entry.should have(1).entry
              cash_amount = transferred_job.total_price * (profit_split.cash_rate.delete(',').to_f / 100.0) * (profit_split.rate / 100.0)

              visit accounting_entries_path('accounting_entry[account_id]' => provider_org_acc.id)
              should have_entry(entries.first, amount: -transferred_job.total_price, status: 'cleared', type: CashCollectionForProvider.model_name.human)
              should have_entry(cash_entry.first, amount: -cash_amount, status: 'cleared', type: CashPaymentFee.model_name.human)
            end

            it 'subcontractor view: account balance should be set to the difference between the total price and cost' do
              cash_amount = transferred_job.total_price * (profit_split.cash_rate.delete(',').to_f / 100.0)
              visit affiliate_path(provider)
              the_profit = (transferred_job.total_price - transferred_job.total_cost - cash_amount)
              should have_affiliate_balance(-(transferred_job.total_price - the_profit *(profit_split.rate/100.0) - transferred_job.total_cost))

            end

            it "technician's account should show cash collection for employer with pending status (withdrawal)"

            describe 'cancel the job: ' do
              before do
                click_button JOB_BTN_CANCEL
              end


              it 'trying to visit customer account should show no entries and not have the customer available ' do
                visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                click_button ACC_BTN_GET_ENTRIES

                entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                entries.should have(0).entry
                should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

              end

              describe 'affiliate account' do
                before do
                  visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                  click_button ACC_BTN_GET_ENTRIES
                end

                it 'subcon view: should show entry and a balance of the job amount minus the parts' do
                  transferred_job.reload
                  accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                  expected_amount  = expected_subcon_cut_cash + cash_fee

                  should have_entry(accounting_entry, amount: expected_amount)
                  should have_affiliate_balance(boms_cost)

                end

              end


            end

            describe 'when the payment is marked as deposited by the subcontractor' do

              before do
                visit service_call_path(transferred_job)
                click_button JOB_BTN_DEPOSIT
              end
              it 'subcon view: account should show the entry as deposited and the balance is updated' do
                entries = provider_org_acc.entries.where(type: CashDepositToProvider, ticket_id: transferred_job.id)

                visit affiliate_path(provider)
                should have_entry(entries.first, status: 'deposited', type: CashDepositToProvider.model_name.human)
                should have_affiliate_balance(expected_subcon_cut_cash)

              end


              it "technician's account should show the entry as deposited"
              it "technician's account should now have the amount type as income"

              describe 'when subcon confirmes on behalf of local provider' do
                before do
                  visit service_call_path(transferred_job)
                  click_button JOB_BTN_PROV_CONFIRMED_DEPOSIT

                end
                it 'subcon view: account should show the entry as cleared' do
                  entries = provider_org_acc.entries.where(type: CashDepositToProvider, ticket_id: transferred_job.id)
                  entries.should have(1).entry
                  visit affiliate_path(provider)
                  should have_entry(entries.first, status: 'cleared')
                end
                it "technician's account should show the entry as cleared"
              end
            end

          end
          describe 'with credit card payment' do
            before do
              select CreditCard.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_COLLECT
            end


            it 'trying to visit customer account should show no entries and not have the customer available ' do
              visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
              click_button ACC_BTN_GET_ENTRIES

              entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
              entries.should have(0).entry
              should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

            end

            it 'subcon view: account should show credit card collection for provider with cleared status (withdrawal) with the right balance' do
              entries = provider_org_acc.entries.where(type: CreditCardCollectionForProvider, ticket_id: transferred_job.id)
              entries.all.should have(1).entry

              credit_entry = provider_org_acc.entries.scoped.where(type: CreditPaymentFee, ticket_id: transferred_job.id)
              credit_entry.should have(1).entry
              credit_amount = transferred_job.total_price * (profit_split.credit_rate.delete(',').to_f / 100.0)

              visit accounting_entries_path('accounting_entry[account_id]' => provider_org_acc.id)
              should have_entry(entries.first, amount: -transferred_job.total_price, status: 'cleared', type: CreditCardCollectionForProvider.model_name.human)
              should have_entry(credit_entry.first, amount: -credit_amount * (profit_split.rate / 100.0), status: 'cleared', type: CreditPaymentFee.model_name.human)
              should have_affiliate_balance(-(transferred_job.total_price - (((transferred_job.total_price - transferred_job.total_cost - credit_amount)*(profit_split.rate/100.0)) + transferred_job.total_cost)))
            end

            it "technician's account should not have additional entries"
            describe 'cancel the job: ' do
              before do
                click_button JOB_BTN_CANCEL
              end


              it 'trying to visit customer account should show no entries and not have the customer available ' do
                visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                click_button ACC_BTN_GET_ENTRIES

                entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                entries.should have(0).entry
                should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

              end

              describe 'affiliate account' do
                before do
                  visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                  click_button ACC_BTN_GET_ENTRIES
                end

                it 'subcon view: should show entry and a balance of the job amount minus the parts' do
                  transferred_job.reload
                  accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                  expected_amount  = expected_subcon_cut_credit + credit_fee

                  should have_entry(accounting_entry, amount: expected_amount)
                  should have_affiliate_balance(boms_cost)

                end
              end
            end

            describe 'when marked as deposited by the subcontractor' do

              before do
                visit service_call_path(transferred_job)
                click_button JOB_BTN_DEPOSIT
              end
              it 'subcon view: account should show the entry as deposited and the balance is updated' do
                entries = provider_org_acc.entries.where(type: CreditCardDepositToProvider, ticket_id: transferred_job.id)

                visit affiliate_path(provider)
                should have_entry(entries.first, status: 'deposited', type: CreditCardDepositToProvider.model_name.human)
                should have_affiliate_balance(expected_subcon_cut_credit)

              end

              it "technician's account should show the entry as deposited"
              it "technician's account should now have the amount type as income"
              describe 'cancel the job: ' do
                before do
                  click_button JOB_BTN_CANCEL
                end


                it 'trying to visit customer account should show no entries and not have the customer available ' do
                  visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                  click_button ACC_BTN_GET_ENTRIES

                  entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                  entries.should have(0).entry
                  should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

                end

                describe 'affiliate account' do
                  before do
                    visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                    click_button ACC_BTN_GET_ENTRIES
                  end

                  it 'subcon view: should show entry and a balance of the job amount minus the parts' do
                    transferred_job.reload
                    accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                    expected_amount  = -(expected_subcon_cut_credit - transferred_job.total_cost)

                    should have_entry(accounting_entry, amount: expected_amount)
                    should have_affiliate_balance(transferred_job.total_cost)

                  end
                end
              end

              describe 'when provider confirms the deposit ' do
                before do
                  visit service_call_path(transferred_job)
                  click_button JOB_BTN_PROV_CONFIRMED_DEPOSIT

                end
                it 'subcon view: account should show the entry as cleared' do
                  entries = provider_org_acc.entries.where(type: CreditCardDepositToProvider, ticket_id: transferred_job.id)
                  entries.should have(1).entry
                  visit affiliate_path(transferred_job.provider)
                  should have_entry(entries.first, status: 'cleared')
                end
                it "subcontractor's account should show the entry as cleared"
                it "technician's account should show the entry as cleared"
              end
            end

          end
          describe 'with cheque payment' do
            before do
              select Cheque.model_name.human, from: JOB_SELECT_PAYMENT
              click_button JOB_BTN_COLLECT
            end

            it 'subcon view: account should show cheque collection to provider with pending status (withdrawal)' do
              entries = provider_org_acc.entries.where(type: ChequeCollectionForProvider, ticket_id: transferred_job.id)
              entries.all.should have(1).entry
              visit affiliate_path(transferred_job.reload.provider)

              entry = provider_org_acc.entries.scoped.where(type: ChequePaymentFee, ticket_id: transferred_job.id)
              entry.should have(1).entry
              amount = transferred_job.total_price * (profit_split.cheque_rate.delete(',').to_f / 100.0)

              visit accounting_entries_path('accounting_entry[account_id]' => provider_org_acc.id)
              should have_entry(entries.first, amount: -transferred_job.total_price, status: 'cleared', type: ChequeCollectionForProvider.model_name.human)
              should have_entry(entry.first, amount: -amount * (profit_split.rate / 100.0), status: 'cleared', type: ChequePaymentFee.model_name.human)
              should have_affiliate_balance(-(transferred_job.total_price - (((transferred_job.total_price - transferred_job.total_cost - amount)*(profit_split.rate/100.0)) + transferred_job.total_cost)))

            end

            it "technician's account should show pending check collection for employer withdrawal"

            describe 'cancel the job: ' do
              before do
                click_button JOB_BTN_CANCEL
              end

              it 'trying to visit customer account should show no entries and not have the customer available ' do
                visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                click_button ACC_BTN_GET_ENTRIES

                entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                entries.should have(0).entry
                should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

              end

              describe 'affiliate account' do
                before do
                  visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                  click_button ACC_BTN_GET_ENTRIES
                end

                it 'subcon view: should show entry and a balance of the job amount minus the parts' do
                  transferred_job.reload
                  accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                  expected_amount  = expected_subcon_cut_cheque + cheque_fee

                  should have_entry(accounting_entry, amount: expected_amount)
                  should have_affiliate_balance(boms_cost)

                end
              end
            end


            describe 'when the cheque is marked as deposited by the subcontractor' do

              before do
                visit service_call_path(transferred_job)
                click_button JOB_BTN_DEPOSIT
              end
              it 'subcon view: account should show the entry as deposited and the balance is updated' do
                entries = provider_org_acc.entries.where(type: ChequeDepositToProvider, ticket_id: transferred_job.id)

                visit affiliate_path(transferred_job.provider)
                should have_entry(entries.first, status: 'deposited', type: ChequeDepositToProvider.model_name.human)
                should have_affiliate_balance(expected_subcon_cut_cheque)

              end

              it "technician's account should show the entry as deposited"
              it "technician's account should now have the amount type as income"

              describe 'cancel the job: ' do
                before do
                  click_button JOB_BTN_CANCEL
                end

                it 'trying to visit customer account should show no entries and not have the customer available ' do
                  visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                  click_button ACC_BTN_GET_ENTRIES

                  entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                  entries.should have(0).entry
                  should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

                end

                describe 'affiliate account' do
                  before do
                    visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                    click_button ACC_BTN_GET_ENTRIES
                  end

                  it 'subcon view: should show entry and a balance of the job amount minus the parts' do
                    transferred_job.reload
                    accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                    expected_amount  = -(expected_subcon_cut_cheque - transferred_job.total_cost)

                    should have_entry(accounting_entry, amount: expected_amount)
                    should have_affiliate_balance(transferred_job.total_cost)

                  end
                end
              end

              describe 'when provider confirms the deposit ' do
                before do
                  visit service_call_path(transferred_job)
                  click_button JOB_BTN_PROV_CONFIRMED_DEPOSIT

                end
                it 'subcon view: account should show the entry as cleared' do
                  entries = provider_org_acc.entries.where(type: ChequeDepositToProvider, ticket_id: transferred_job.id)
                  entries.should have(1).entry
                  visit affiliate_path(transferred_job.provider)
                  should have_entry(entries.first, status: 'cleared')
                end

                it "technician's account should show the entry as cleared"

                describe 'cancel the job: ' do
                  before do
                    click_button JOB_BTN_CANCEL
                  end

                  it 'trying to visit customer account should show no entries and not have the customer available ' do
                    visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                    click_button ACC_BTN_GET_ENTRIES

                    entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                    entries.should have(0).entry
                    should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

                  end

                  describe 'affiliate account' do
                    before do
                      visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                      click_button ACC_BTN_GET_ENTRIES
                    end

                    it 'subcon view: should show entry and a balance of the job amount minus the parts' do
                      transferred_job.reload
                      accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                      expected_amount  = -(expected_subcon_cut_cheque - transferred_job.total_cost)

                      should have_entry(accounting_entry, amount: expected_amount)
                      should have_affiliate_balance(transferred_job.total_cost)

                    end
                  end
                end
              end
            end


          end

        end

        describe 'when invoiced by provider' do
          before do
            visit service_call_path(transferred_job)
            click_button JOB_BTN_PROV_INVOICE
          end

          it 'should not create accounting entry' do
            expect {}.to_not change(AccountingEntry, :count)
          end

          # if the prov invoiced he should also collect
          it 'should NOT show a select of payment type with a paid button' do
            should_not have_select JOB_SELECT_PAYMENT
            should_not have_button JOB_BTN_PAID
          end

          it 'trying to visit customer account should show no entries and not have the customer available ' do
            visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
            click_button ACC_BTN_GET_ENTRIES

            entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
            entries.should have(0).entry
            should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

          end

          it "should NOT send an invoice to the customer"

          describe 'cancel the job: ' do
            before do
              click_button JOB_BTN_CANCEL
            end

            it 'trying to visit customer account should show no entries and not have the customer available ' do
              visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
              click_button ACC_BTN_GET_ENTRIES

              entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
              entries.should have(0).entry
              should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

            end

            describe 'affiliate account' do
              before do
                visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                click_button ACC_BTN_GET_ENTRIES
              end

              it 'subcon view: should show entry and a balance of the job amount minus the parts' do
                transferred_job.reload
                accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                expected_amount  = -(transferred_job.total_profit * accounting_entry.amount_direction) * (profit_split.rate / 100.0)

                should have_entry(accounting_entry, amount: expected_amount)
                should have_affiliate_balance(transferred_job.total_cost)

              end
            end
          end
        end

        describe 'settlement with provider (local)' do
          before do
            visit service_call_path(transferred_job)
            click_button JOB_BTN_INVOICE
            select Cheque.model_name.human, from: JOB_SELECT_PAYMENT
            click_button JOB_BTN_COLLECT
            click_button JOB_BTN_DEPOSIT
            click_button JOB_BTN_PROV_CONFIRMED_DEPOSIT
          end

          it 'subcon view: settlement button and provider payment should be available' do
            should have_select JOB_SELECT_PROVIDER_PAYMENT
            should have_button JOB_BTN_SETTLE
          end

          it 'subcon view: should not allow settlement without choosing a payment' do
            click_button JOB_BTN_SETTLE
            should have_selector 'div.alert-error'
          end

          describe 'user indicates the job is settled ' do

            describe 'with cash' do

              before do
                select Cash.model_name.human, from: JOB_SELECT_PROVIDER_PAYMENT
                click_button JOB_BTN_SETTLE
              end

              it 'subcontractor view: status should be set to Settled' do
                should have_provider_status(JOB_PROVIDER_STATUS_SETTLED)
              end

              it 'subcon view: account should have a cash payment entry with cleared status' do
                visit affiliate_path(transferred_job.reload.provider)

                entries = provider_org_acc.entries.where(type: CashPaymentFromAffiliate, ticket_id: transferred_job.id)
                entries.should have(1).entry
                should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: CashPaymentFromAffiliate.model_name.human, status: 'cleared')
                should have_affiliate_balance(0)
              end
              describe 'cancel the job: ' do
                before do
                  click_button JOB_BTN_CANCEL
                end


                it 'trying to visit customer account should show no entries and not have the customer available ' do
                  visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                  click_button ACC_BTN_GET_ENTRIES

                  entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                  entries.should have(0).entry
                  should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

                end

                describe 'affiliate account' do
                  before do
                    visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                    click_button ACC_BTN_GET_ENTRIES
                  end

                  it 'subcon view: should show entry and a balance of the job subcon cut amount' do
                    transferred_job.reload
                    accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                    expected_amount  = expected_subcon_cut_cheque -  transferred_job.total_cost

                    should have_entry(accounting_entry, amount: - expected_amount)
                    should have_affiliate_balance(-expected_amount)

                  end

                end


              end

            end
            describe 'with credit card' do
              before do
                select CreditCard.model_name.human, from: JOB_SELECT_PROVIDER_PAYMENT
                click_button JOB_BTN_SETTLE
              end

              it 'subcontractor view: status should be set to Settled' do
                should have_provider_status(JOB_PROVIDER_STATUS_SETTLED)
              end

              it 'subcon view: account should have a cash payment entry with deposited status' do
                visit affiliate_path(transferred_job.reload.provider)

                entries = provider_org_acc.entries.where(type: CreditPaymentFromAffiliate, ticket_id: transferred_job.id)
                entries.should have(1).entry
                should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: CreditPaymentFromAffiliate.model_name.human, status: 'deposited')
                should have_affiliate_balance(0)
              end
              describe 'cancel the job: ' do
                before do
                  click_button JOB_BTN_CANCEL
                end


                it 'trying to visit customer account should show no entries and not have the customer available ' do
                  visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                  click_button ACC_BTN_GET_ENTRIES

                  entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                  entries.should have(0).entry
                  should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

                end

                describe 'affiliate account' do
                  before do
                    visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                    click_button ACC_BTN_GET_ENTRIES
                  end

                  it 'subcon view: should show entry and a balance of the job subcon cut amount' do
                    transferred_job.reload
                    accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                    expected_amount  = - (expected_subcon_cut_cheque - transferred_job.total_cost)

                    should have_entry(accounting_entry, amount: expected_amount)
                    should have_affiliate_balance( expected_amount)

                  end

                end


              end

              describe "clear deposit" do
                pending
              end

            end
            describe 'with cheque' do
              before do
                select Cheque.model_name.human, from: JOB_SELECT_PROVIDER_PAYMENT
                click_button JOB_BTN_SETTLE
              end

              it 'subcontractor view: status should be set to Settled' do
                should have_provider_status(JOB_PROVIDER_STATUS_SETTLED)
              end

              it 'subcon view: account should have a cheque payment entry with cleared status' do
                visit affiliate_path(transferred_job.reload.provider)

                entries = provider_org_acc.entries.where(type: ChequePaymentFromAffiliate, ticket_id: transferred_job.id)
                entries.should have(1).entry
                should have_entry(entries.first, amount: -expected_subcon_cut_cheque, type: ChequePaymentFromAffiliate.model_name.human, status: 'deposited')
                should have_affiliate_balance(0)
              end

              describe 'cancel the job: ' do
                before do
                  click_button JOB_BTN_CANCEL
                end


                it 'trying to visit customer account should show no entries and not have the customer available ' do
                  visit accounting_entries_path('accounting_entry[account_id]' => transferred_job.customer.account)
                  click_button ACC_BTN_GET_ENTRIES

                  entries = transferred_job.customer.account.entries.where(type: CanceledJobAdjustment)
                  entries.should have(0).entry
                  should_not have_select(ACC_SELECT, with_options: [transferred_job.customer.name])

                end

                describe 'affiliate account' do
                  before do
                    visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, provider).first.id)
                    click_button ACC_BTN_GET_ENTRIES
                  end

                  it 'subcon view: should show entry and a balance of the job subcon cut amount' do
                    transferred_job.reload
                    accounting_entry = provider_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: transferred_job.id).first
                    expected_amount  = -(expected_subcon_cut_cheque - transferred_job.total_cost)

                    should have_entry(accounting_entry, amount: expected_amount)
                    should have_affiliate_balance(expected_amount)

                  end

                end


              end

              describe 'clear deposit' do
                before do
                  click_button JOB_BTN_PROV_PAYMENT_CLEAR
                end

                it 'provider status should turn to cleared' do
                  should have_provider_status(JOB_PROVIDER_STATUS_CLEARED)
                end
              end
            end
          end
        end
      end
    end
  end

  describe 'transfer service call to a local subcon' do
    let!(:subcon) { setup_profit_split_agreement(org, FactoryGirl.create(:subcontractor)).counterparty }
    let(:subcon_org_acc) { Account.for_affiliate(org, subcon).first }

    before do
      transfer_job(job, subcon)
      click_button JOB_BTN_ACCEPT
      click_button JOB_BTN_START
      add_bom bom1[:name], bom1[:cost], bom1[:price], bom1[:quantity], subcon.name
      add_bom bom2[:name], bom2[:cost], bom2[:price], bom2[:quantity], subcon.name

    end

    describe 'when completed' do
      before do
        click_button JOB_BTN_COMPLETE
        visit accounting_entries_path('accounting_entry[account_id]' => subcon_org_acc.id)
        click_button ACC_BTN_GET_ENTRIES
      end

      it 'should show the payment to subcon and the correct balance' do
        job.reload

        accounting_entry = subcon_org_acc.entries.scoped.where(type: 'PaymentToSubcontractor', ticket_id: job.id)
        accounting_entry.should have(1).entry
        expected_entry_amount = (job.total_profit * accounting_entry.first.amount_direction) * (profit_split.rate / 100.0)


        should have_entry(accounting_entry.first, amount: expected_entry_amount)
        should have_balance(-job.total_cost + expected_entry_amount)

      end

      describe 'cancel the job: ' do
        before do
          visit service_call_path(job)
          click_button JOB_BTN_CANCEL
        end


        describe 'customer account' do
          before do
            visit accounting_entries_path('accounting_entry[account_id]' => customer.account.id)
            #click_button ACC_BTN_GET_ENTRIES
          end

          it 'should show canceled job entry with a zero balance' do
            entries = job.reload.customer.account.entries.where(type: CanceledJobAdjustment)
            entries.should have(1).entry
            should have_entry(entries.first, amount: -expected_price, type: CanceledJobAdjustment.model_name.human)
            should have_customer_balance(0)

          end

        end

        describe 'affiliate account' do
          before do
            visit accounting_entries_path('accounting_entry[account_id]' => Account.for_affiliate(org, subcon).first.id)
            click_button ACC_BTN_GET_ENTRIES
          end

          it 'subcon account: should show  a cancellation entry and a balance of zero' do
            job.reload
            accounting_entry = subcon_org_acc.entries.scoped.where(type: 'CanceledJobAdjustment', ticket_id: job.id).first
            expected_amount  = (job.total_profit * accounting_entry.amount_direction) * (profit_split.rate / 100.0)

            should have_entry(accounting_entry, amount: expected_amount)
            should have_affiliate_balance(-(bom1[:total_cost] + bom2[:total_cost]))

          end

        end


      end
    end


  end


end

