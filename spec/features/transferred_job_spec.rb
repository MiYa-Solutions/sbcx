require 'spec_helper'
require 'capybara/rspec'

describe 'Transferred Job', js: true do
  self.use_transactional_fixtures = false

  setup_org


  before do
    in_browser(:org) do
      sign_in org_admin_user
    end
  end

  subject { page }

  describe 'with local provider' do
    let(:provider) { setup_profit_split_agreement(FactoryGirl.create(:provider), org).organization }
    let(:job) { create_transferred_job(org_admin_user, provider, :org) }
    let(:provider_acc) { Account.for_affiliate(org, provider).first }

    before do
      job.reload
    end

    it 'should show the accept and reject buttons' do
      should have_button JOB_BTN_ACCEPT
      should have_button JOB_BTN_REJECT
    end

    describe "reject the job" do
      pending
    end


    describe 'accept the job' do

      before do
        click_button JOB_BTN_ACCEPT
      end

      it 'should show a success message' do
        should have_selector('.alert-success')
      end

      it 'status should be accepted' do
        should have_status(JOB_STATUS_ACCEPTED)
      end

      it 'should show buttons: canceled, un-accept, start, transfer' do
        should have_button(JOB_BTN_CANCEL)
        should have_button(JOB_BTN_UN_ACCEPT)
        should have_button(JOB_BTN_START)
        should have_button(JOB_BTN_TRANSFER)
      end

      describe 'cancel the job' do
        before do
          click_button JOB_BTN_CANCEL
        end

        it 'should show a canceled status' do
          should have_status(JOB_STATUS_CANCELED)
        end

        it 'should have a cancel event' do
          #click_button JOB_BTN_HISTORY
          should have_event('100003', I18n.t('service_call_cancel_event.name'))
        end
      end

      describe "un accept the job" do
        pending
      end

      describe "transfer the job"  do
        pending
      end

      describe 'start the job' do
        before do
          click_button JOB_BTN_START
        end

        it 'should show a success message' do
          should have_selector('.alert-success')
        end

        it 'work status should be in progress' do
          should have_work_status(JOB_WORK_STATUS_IN_PROGRESS)
        end

        it 'should show buttons: canceled, un-accept, complete' do
          should have_button(JOB_BTN_CANCEL)
          should have_button(JOB_BTN_UN_ACCEPT)
          should have_button(JOB_BTN_COMPLETE)
        end

        describe "un accept the job" do
          pending
        end

        describe 'cancel the job' do
          before do
            click_button JOB_BTN_CANCEL
          end

          it 'should show a canceled status' do
            should have_status(JOB_STATUS_CANCELED)
          end

          it 'should have a cancel event' do
            #click_button JOB_BTN_HISTORY
            should have_event('100003', I18n.t('service_call_cancel_event.name'))
          end

          it 'should not show a complete or close buttons' do
            should_not have_button(JOB_BTN_COMPLETE)
            should_not have_button(JOB_BTN_CLOSE)
          end
        end

        describe 'complete the job' do
          before do
            add_bom 'test bom 1', 10, 100, 1
            add_bom 'test bom 2', 20, 200, 1
            click_button JOB_BTN_COMPLETE
          end

          it 'should show a success message' do
            should have_success_message
          end

          it 'should show work status as completed' do
            should have_work_status(JOB_WORK_STATUS_COMPLETED)
          end

          it 'should have buttons: cancel, invoice, provider invoiced and not un-accept and not cancel transfer' do
            should have_button(JOB_BTN_CANCEL)
            should have_button(JOB_BTN_INVOICE)
            should have_button(JOB_BTN_PROV_INVOICE)
            should_not have_button(JOB_BTN_UN_ACCEPT)
            should_not have_button(JOB_BTN_CANCEL_TRANSFER)
          end

          describe 'cancel the job' do
            before do
              click_button JOB_BTN_CANCEL
            end

            it 'should show a canceled status' do
              should have_status(JOB_STATUS_CANCELED)
            end

            it 'should have a cancel event' do
              #click_button JOB_BTN_HISTORY
              should have_event('100003', I18n.t('service_call_cancel_event.name'))
            end

            it 'should not show a settle or close buttons' do
              should_not have_button(JOB_BTN_SETTLE)
              should_not have_button(JOB_BTN_CLOSE)
            end

          end


          describe 'invoice the customer' do
            before do
              click_button JOB_BTN_INVOICE
            end

            it 'should show a success message' do
              should have_success_message
            end

            it 'should show the billing status as invoiced' do
              should have_billing_status(JOB_BILLING_STATUS_INVOICED)
            end

            it 'actions have : cancel btn, collect btn, provider collected btn, payment select ' do
              should have_button(JOB_BTN_CANCEL)
              should have_button(JOB_BTN_COLLECT)
              should have_button(JOB_BTN_PROV_COLLECT)
              should have_select(JOB_SELECT_PAYMENT, options: ["", Cash.model_name.human, CreditCard.model_name.human, Cheque.model_name.human])
            end

            describe 'cancel the job' do
              before do
                click_button JOB_BTN_CANCEL
              end

              it 'should show a canceled status' do
                should have_status(JOB_STATUS_CANCELED)
              end

              it 'should have a cancel event' do
                #click_button JOB_BTN_HISTORY
                should have_event('100003', I18n.t('service_call_cancel_event.name'))
              end

              it 'should not show a settle or close buttons' do
                should_not have_button(JOB_BTN_SETTLE)
                should_not have_button(JOB_BTN_CLOSE)
              end

            end

            describe 'collect the payment' do
              before do
                select Cash.model_name.human, from: JOB_SELECT_PAYMENT
                click_button JOB_BTN_COLLECT
              end

              it 'should show a success message' do
                should have_success_message
              end

              it 'billing status should be set to collected' do
                should have_billing_status(JOB_BILLING_STATUS_COLLECTED)
              end

              it 'actions should show cancel and deposited buttons' do
                should have_button(JOB_BTN_DEPOSIT)
                should have_button(JOB_BTN_CANCEL)
              end

              describe 'cancel the job' do
                before do
                  click_button JOB_BTN_CANCEL
                end

                it 'should show a canceled status' do
                  should have_status(JOB_STATUS_CANCELED)
                end

                it 'should have a cancel event' do
                  #click_button JOB_BTN_HISTORY
                  should have_event('100003', I18n.t('service_call_cancel_event.name'))
                end

                it 'should not show a settle or close buttons' do
                  should_not have_button(JOB_BTN_SETTLE)
                  should_not have_button(JOB_BTN_CLOSE)
                end

              end

              describe 'deposit the payment' do

                before do
                  click_button JOB_BTN_DEPOSIT
                end
                it 'should show a success message' do
                  should have_success_message
                end

                it 'billing status should be set to claimed deposited' do
                  should have_billing_status(JOB_BILLING_STATUS_DEPOSITED_TO_PROV)
                end

                it 'actions should show cancel and prov confirmed deposit buttons' do
                  should have_button(JOB_BTN_CANCEL)
                  should have_button(JOB_BTN_PROV_CONFIRMED_DEPOSIT)
                end

                describe 'cancel the job' do
                  before do
                    click_button JOB_BTN_CANCEL
                  end

                  it 'should show a canceled status' do
                    should have_status(JOB_STATUS_CANCELED)
                  end

                  it 'should have a cancel event' do
                    #click_button JOB_BTN_HISTORY
                    should have_event('100003', I18n.t('service_call_cancel_event.name'))
                  end

                  it 'should not show a settle or close buttons' do
                    should_not have_button(JOB_BTN_SETTLE)
                    should_not have_button(JOB_BTN_CLOSE)
                  end

                end


                describe 'confirm deposit on behalf of the provider' do
                  before do
                    click_button JOB_BTN_PROV_CONFIRMED_DEPOSIT
                  end
                  it 'should show a success message' do
                    should have_success_message
                  end

                  it 'billing status should be set to claimed deposited' do
                    should have_billing_status(JOB_BILLING_STATUS_DEPOSIT_CONFIRMED)
                  end

                  it 'actions should show cancel btn, settle btn and provider payment select' do
                    should have_button(JOB_BTN_CANCEL)
                    should have_button(JOB_BTN_SETTLE)
                    should have_select(JOB_SELECT_PROVIDER_PAYMENT, options: [Cash.model_name.human, CreditCard.model_name.human, Cheque.model_name.human, ""])
                  end

                  describe 'cancel the job' do
                    before do
                      click_button JOB_BTN_CANCEL
                    end

                    it 'should show a canceled status' do
                      should have_status(JOB_STATUS_CANCELED)
                    end

                    it 'should have a cancel event' do
                      #click_button JOB_BTN_HISTORY
                      should have_event('100003', I18n.t('service_call_cancel_event.name'))
                    end

                    it 'should show a settle and cancel buttons' do
                      should have_button(JOB_BTN_SETTLE)
                      should_not have_button(JOB_BTN_CLOSE)
                    end

                  end


                  describe 'settle with provider' do
                    before do
                      select Cash.model_name.human, from: JOB_SELECT_PROVIDER_PAYMENT
                      click_button  JOB_BTN_SETTLE
                    end

                    it 'should show a success message' do
                      should have_success_message
                    end

                    it 'provider status should be set to settled' do
                      should have_provider_status(JOB_PROVIDER_STATUS_SETTLED)
                    end

                    it 'actions should show cancel and provider clear buttons and not close' do
                      should have_button(JOB_BTN_CANCEL)
                      should have_button(JOB_BTN_PROV_PAYMENT_CLEAR)
                      should_not have_button(JOB_BTN_CLOSE)
                    end

                    describe 'cancel the job' do
                      before do
                        click_button JOB_BTN_CANCEL
                      end

                      it 'should show a canceled status' do
                        should have_status(JOB_STATUS_CANCELED)
                      end

                      it 'should have a cancel event' do
                        #click_button JOB_BTN_HISTORY
                        should have_event('100003', I18n.t('service_call_cancel_event.name'))
                      end

                      it 'should not show a settle or close buttons' do
                        should_not have_button(JOB_BTN_SETTLE)
                        should_not have_button(JOB_BTN_CLOSE)
                      end

                    end

                    describe 'clear deposit' do
                      before do
                        click_button JOB_BTN_PROV_PAYMENT_CLEAR
                      end

                      it 'provider status should turn to cleared' do
                        should have_provider_status(JOB_PROVIDER_STATUS_CLEARED)
                      end

                      it 'actions should show cancel and provider clear buttons and not close' do
                        should have_button(JOB_BTN_CANCEL)
                        should have_button(JOB_BTN_CLOSE)
                      end

                      describe 'close job' do
                        before do
                          click_button JOB_BTN_CLOSE
                        end

                        it 'should show a success message' do
                          should have_success_message
                        end

                        it 'status should be set to closed' do
                          should have_status(JOB_STATUS_CLOSED)
                        end

                        it 'actions should not show any button' do
                          should_not have_button(JOB_BTN_CANCEL)
                        end

                        it 'should have the close event associated' do
                          should have_event('100036')
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

    end

  end


end