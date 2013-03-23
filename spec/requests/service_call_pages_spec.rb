require 'spec_helper'
require 'capybara/rspec'

describe "Service Call pages" do

  # ==============================================================
  # data elements to inspect
  # ==============================================================
  service_call_started_on        = '.service_call_started_on'
  service_call_completed_on      = '.service_call_completed_on'
  subcontractor_select           = 'service_call_subcontractor_id'
  provider_select                = 'select#service_call_provider_id'
  technician_select              = 'service_call_technician_id'
  collector_select               = 'select#service_call_collector_id'
  collector_select_selector      = 'service_call_collector_id'
  status_select                  = 'service_call_status_event'
  work_status_select             = 'service_call_work_status_event'
  customer_select                = 'service_call_customer_id'
  new_customer_fld               = 'service_call_new_customer'
  notification_counter           = '#notification-counter'
  notifications                  = '#notifications'


  # ==============================================================
  # buttons to click and inspect
  # ==============================================================
  transfer_btn                   = '#service_call_transfer_btn'
  transfer_btn_selector          = 'service_call_transfer_btn'
  dispatch_btn                   = '#service_call_dispatch_btn'
  dispatch_btn_selector          = 'service_call_dispatch_btn'
  create_btn                     = 'service_call_create_btn'
  create_btn_selector            = 'service_call_create_btn'
  accept_btn                     = '#accept_service_call_btn'
  accept_btn_selector            = 'accept_service_call_btn'
  reject_btn                     = '#reject_service_call_btn'
  reject_btn_selector            = 'reject_service_call_btn'
  settle_btn                     = '#settle_service_call_btn'
  settle_btn_selector            = 'settle_service_call_btn'
  start_btn                      = '#start_service_call_btn'
  start_btn_selector             = 'start_service_call_btn'
  complete_btn                   = '#complete_service_call_btn'
  complete_btn_selector          = 'complete_service_call_btn'
  paid_btn                       = '#paid_service_call_btn'
  paid_btn_selector              = 'job_paid_btn'
  save_btn                       = '#service_call_save_btn'
  save_btn_selector              = 'service_call_save_btn'
  cancel_btn                     = '#cancel_service_call_btn'
  cancel_btn_selector            = 'cancel_service_call_btn'
  un_cancel_btn                  = '#un_cancel_service_call_btn'
  un_cancel_btn_selector         = 'un_cancel_service_call_btn'
  allow_collection_cbox          = '#service_call_allow_collection'
  allow_collection_cbox_selector = 'service_call_allow_collection'
  re_transfer_cbox               = '#service_call_re_transfer'
  re_transfer_cbox_selector      = 'service_call_re_transfer'
  invoice_btn_selector           = 'invoice_service_call_btn'
  provider_invoiced_btn_selector = 'provider_invoiced_service_call_btn'
  provider_invoiced_btn          = '#provider_invoiced_service_call_btn'
  collect_btn_selector           = 'collect_service_call_btn'
  collect_btn                    = '#collect_service_call_btn'
  deposit_btn_selector           = 'deposit_service_call_btn'
  deposit_btn                    = '#desposit_service_call_btn'
  employee_deposit_btn_selector  = 'employee_deposit_service_call_btn'
  employee_deposit_btn           = '#employee_desposit_service_call_btn'
  deposit_to_prov_btn_selector   = 'deposit_to_prov_service_call_btn'
  deposit_to_prov_btn            = '#deposit_to_prov_service_call_btn'
  confirm_deposit_btn_selector   = 'confirm_deposit_service_call_btn'
  confirm_deposit_btn            = '#confirm_deposit_service_call_btn'
  payment_overdue_btn_selector   = 'overdue_service_call_btn'
  payment_overdue_btn            = '#overdue_service_call_btn'
  confirm_settled_btn_selector   = 'confirm_settled_service_call_btn'
  confirm_settled_btn            = '#confirm_settled_service_call_btn'


  describe "with Org Admin", js: true do
    self.use_transactional_fixtures = false

    let!(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
    let!(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
    let!(:org_admin_user3) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
    let!(:org) { org_admin_user.organization }
    let!(:org2) {
      setup_profit_split_agreement(org_admin_user2.organization, org.becomes(Subcontractor))
      setup_profit_split_agreement(org, org_admin_user2.organization.becomes(Subcontractor)).counterparty
    }
    let!(:org3) do
      setup_profit_split_agreement(org_admin_user3.organization, org_admin_user.organization.becomes(Subcontractor))
      setup_profit_split_agreement(org2, org_admin_user3.organization.becomes(Subcontractor)).counterparty
    end

    # local provider of org
    let!(:provider) {
      prov = FactoryGirl.create(:provider)
      setup_profit_split_agreement(prov, org.becomes(Subcontractor)).organization
    }

    let!(:subcontractor) {
      org2.becomes(Subcontractor)
    }

    let!(:customer) { FactoryGirl.create(:customer, organization: org) }

    before do
      in_browser(:org) do
        sign_in org_admin_user
      end

      in_browser(:org2) do
        sign_in org_admin_user2
      end


    end

    after do
      clean org unless org.nil?
      clean org2 unless org2.nil?
      clean org3 unless org3.nil?
    end

    subject { page }

    describe "new service call page" do


      #initialize orgs provider, customer, etc.
      before do
        #provider.save!
        #customer.save!
        #org2 # initialize org2 to ensure it is avilable in the select box
        in_browser(:org) do
          with_user(org_admin_user) do
            visit new_service_call_path
          end
        end

      end


      describe "customer selection" do
        pending "updated when changing the provider with the associated customers"
      end

      describe "transferred service call" do


        describe "when the provider is a member" do
          before do
            in_browser(:org) do
              select org2.name, from: 'service_call_provider_id'
              fill_in 'service_call_customer', with: customer.name
            end
          end

          it "should not allow to create, as the service call should originate from the provider" do
            expect do
              click_button create_btn
            end.to_not change(ServiceCall, :count)
          end
        end

        describe "when the provider is NOT a member (local)" do
          #let(:local_provider) { FactoryGirl.build(:provider) }

          before do
            #org.providers << provider
            in_browser(:org) do
              visit new_service_call_path
              select provider.name, from: 'service_call_provider_id'
              fill_in new_customer_fld, with: Faker::Name.name

            end
          end

          let(:service_call) { ServiceCall.last }

          # unlike when the provider is a member where a copy of the service call should be created
          it "should create only one service call " do
            expect do
              click_button create_btn
            end.to change(ServiceCall, :count).by(1)
          end

          describe "after the create click" do
            before { click_button create_btn }
            it "should be of type MyServiceCall" do
              service_call.should be_a_kind_of(TransferredServiceCall)
            end

            it "the customer is accessible" do
              visit customer_path service_call.customer
              should have_content(service_call.customer.name)
            end

            it "the customer should belong to the provider" do
              service_call.customer.organization.id.should == service_call.provider.id
            end

          end
        end


      end

      describe "my service call" do

        before do
          in_browser(:org) do
            #auto_complete 'service_call_customer', customer.name
          end
        end

        #after do
        #  clean(org)
        #  clean(org2)
        #  clean(org3)
        #end


        it "should be created successfully" do
          expect do
            fill_autocomplete 'service_call_customer', with: customer.name.chop, select: customer.name
            click_button create_btn
          end.to change(ServiceCall, :count).by(1)
        end

        let(:service_call) { ServiceCall.last }

        it "should be of type MyServiceCall" do
          expect { service_call.should be_a_kind_of(MyServiceCall) }
        end

      end


    end


    describe "my service call" do
      #self.use_transactional_fixtures = false
      let(:service_call) { FactoryGirl.create(:my_service_call, organization: org, customer: customer, subcontractor: nil) }

      before do
        subcontractor.save
        in_browser(:org) do
          visit service_call_path service_call
        end

      end

      it { should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.pending')) }
      it { should have_selector(transfer_btn, value: I18n.t('activerecord.state_machines.my_service_call.status.events.transfer')) }

      it { should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.new')) }

      let(:technician) { FactoryGirl.create(:technician, organization: org) }

      describe "with single user organization" do

        before do
          Rails.logger.debug { "The number of users for org is #{org.users.size}" }
          Rails.logger.debug { "The number of users for org2 is #{org2.users.size}" }
          in_browser(:org) do
            visit service_call_path service_call
          end

        end

        it "should show start instead of dispatch" do
          should have_selector(start_btn)
        end

        it "should not show dispatch" do
          should_not have_selector(dispatch_btn)
        end

        describe "start the job" do
          before do
            click_button start_btn_selector
          end

          it "start time is set" do
            service_call.reload
            service_call.started_on.should_not be_nil
          end
          it "start time is displayed" do
            Time.parse(find(service_call_started_on).text) <= Time.current
          end

          it "work status should change to in progress" do

            should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.in_progress'))

          end
          it "subcontractor status should not be displayed" do
            should_not have_selector(JOB_SUBCONTRACTOR_STATUS)
          end

          it " service call should have a started event associated " do
            service_call.events.pluck(:reference_id).should include(100015)
            service_call.reload
            should have_selector('table#event_log_in_service_call td', content: I18n.t('service_call_start_event.description', technician: service_call.technician.name))
          end
        end

      end

      describe "multi user organization" do


        before do
          technician.valid?
          visit service_call_path service_call
        end

        it { should have_selector(dispatch_btn, value: I18n.t('activerecord.state_machines.my_service_call.status.events.dispatch')) }

      end

      describe "transfer my service call to a member subcontractor" do
        # transfer the service call
        before do
          in_browser(:org) do
            select subcontractor.name, from: subcontractor_select
            check re_transfer_cbox_selector
            check allow_collection_cbox_selector
            click_button transfer_btn_selector
          end
          @subcon_service_call = ServiceCall.find_by_organization_id_and_ref_id(subcontractor.id, service_call.ref_id)
        end

        it "should change the status to transferred" do
          should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))
        end

        it "should change the subcontractor status to pending localized" do

          should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.pending'))
        end

        it " service call should have a Transfer event associated " do
          service_call.events.pluck(:reference_id).should include(100017)
        end
        it " transferred service call should have an Received event associated " do
          @subcon_service_call.events.pluck(:reference_id).should include(100010)
        end

        describe "subcontractor browser" do
          let(:subcon_service_call) { ServiceCall.find_by_organization_id_and_ref_id(subcontractor.id, service_call.ref_id) }

          before(:each) do
            in_browser(:org2) do
              visit service_call_path subcon_service_call
            end
          end

          it "notification counter should indicate a notice" do
            should have_selector(notification_counter, text: "1")
          end
          it "notification should appear in the welcome" do
            visit user_root_path
            should have_selector(notifications, content: /#{service_call.provider.name}/)
          end

          it "should show up in the subcontractors gui with a locelized received_new status" do
            should have_status(I18n.t('activerecord.state_machines.transferred_service_call.status.states.new'))
          end

          it "should not have a subcontractor status displayed" do

            should_not have_subcon_status('')
          end

          it "should allow to accept the service call" do
            should have_selector(accept_btn, value: I18n.t('activerecord.state_machines.transferred_service_call.status.events.accept'))
          end
        end

        describe "subcontractor accepts the service call" do

          # accept the service call
          before do
            in_browser(:org2) do
              visit service_call_path @subcon_service_call
              click_button accept_btn_selector
            end

            in_browser(:org) { visit service_call_path service_call }
          end

          it "status remains transferred" do
            should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))
          end

          it "work status changes to accepted" do

            should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.accepted'))
          end

          it " service call should have an accepted event associated " do
            service_call.events.pluck(:reference_id).should include(100002)
          end
          it " transferred service call should have an accept event associated " do
            @subcon_service_call.events.pluck(:reference_id).should include(100001)
          end


          describe "subcontractor browser" do
            before { in_browser(:org2) {} }

            it " status changed to accepted" do

              should have_status(I18n.t('activerecord.state_machines.transferred_service_call.status.states.accepted'))
            end

            it " subcontractor status remains na" do

              should_not have_subcon_status('')
            end

          end

          describe "subcontractor dispatches the service call" do
            let!(:technician) { FactoryGirl.create(:technician, organization: subcontractor) }
            before do
              in_browser(:org2) do
                visit service_call_path @subcon_service_call
                select technician.name, from: technician_select
                click_button dispatch_btn_selector
              end

              in_browser(:org) { visit service_call_path service_call }
            end

            it "status remains transferred" do

              should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

            end

            it "work status changes to in progress" do

              should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.in_progress'))
            end

            it " service call should have a dispatched event associated " do
              service_call.events.pluck(:reference_id).should include(100008)
            end
            it " transferred service call should have a dispatch event associated " do
              @subcon_service_call.events.pluck(:reference_id).should include(100007)
            end


            describe "subcontractor view after dispatch" do
              before { in_browser(:org2) {} }
              it "status should change to dispatched" do

                should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.dispatched'))

              end
              it "subcontractor status should remain na" do

                should_not have_subcon_status('')

              end
            end

            describe "subcontractor starts the service call" do
              before do
                in_browser(:org2) do
                  visit service_call_path @subcon_service_call
                  click_button start_btn_selector
                end

                in_browser(:org) { visit service_call_path service_call }
              end

              it "status remains transferred" do

                should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

              end
              it "work status remains in progress" do

                should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.in_progress'))
              end
              it "start time is set to the same time as the subcontractor service call" do
                Time.parse(find(service_call_started_on).text) == @subcon_service_call.started_on
              end

              it " service call should have a started event associated " do
                service_call.events.pluck(:reference_id).should include(100016)
              end
              it " transferred service call should have a start event associated " do
                @subcon_service_call.events.pluck(:reference_id).should include(100015)
              end

              describe "subcontractor view after start" do
                before { in_browser(:org2) {} }
                it "work status should change to in progress" do

                  should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.in_progress'))

                end
                it "subcontractor status should remain na" do

                  should_not have_subcon_status('')
                end

                it "start date should be updated with the current time" do
                  Time.parse(find(service_call_started_on).text) <= Time.current
                end


              end

              describe "subcontractor cancels the service call" do

                before do
                  in_browser(:org2) do
                    visit service_call_path @subcon_service_call
                    click_button cancel_btn_selector
                  end

                  in_browser(:org) { visit service_call_path service_call }
                end

                it "should change the status to canceled" do

                  should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.canceled'))
                end

                it "should have canceled event displayed" do
                  should have_selector('table#event_log_in_service_call td', text: I18n.t('service_call_canceled_event.description', subcontractor: org2.name))
                end

                it "should have an un_cancel button" do
                  should have_selector(un_cancel_btn)
                end

                it "subcontractor sc  should be canceled" do
                  in_browser(:org2) do

                    should have_status(I18n.t('activerecord.state_machines.transferred_service_call.status.states.canceled'))
                  end

                end

                describe "un-cancel" do

                  before do
                    in_browser(:org) do
                      visit service_call_path service_call
                      click_button un_cancel_btn_selector
                    end

                  end

                  it "should change the status to pending" do

                    should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.new'))
                  end

                end

              end

              describe "subcontractor completes the service call" do
                before do
                  in_browser(:org2) do
                    add_bom "test part", 10.3, 20.9, 1
                    visit service_call_path @subcon_service_call
                    click_button complete_btn_selector
                  end

                  in_browser(:org) { visit service_call_path service_call }
                end

                it "status remains transferred" do

                  should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

                end
                it "work status changes to completed" do

                  should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.done'))
                end
                it "completion time is equal to the subcontractor completion time" do
                  Time.parse(find(service_call_completed_on).text) == @subcon_service_call.completed_on
                end

                it " service call should have a completed event associated " do
                  service_call.events.pluck(:reference_id).should include(100006)
                end
                it " transferred service call should have a complete event associated " do
                  @subcon_service_call.events.pluck(:reference_id).should include(100005)
                end


                describe "subcontractor view after complete" do
                  before { in_browser(:org2) {} }
                  it "status should change to completed" do

                    should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.done'))

                  end

                  it "completed date should be updated with the current time" do
                    Time.parse(find(service_call_completed_on).text) <= Time.current
                  end

                  it "should NOT show the provider invoice button" do
                    should_not have_selector provider_invoiced_btn_selector
                  end

                end

                describe 'subcontractor is expected to collect the payment' do
                  describe "customer billing" do

                    describe 'subcontractor invoices the customer' do

                      before do
                        in_browser(:org2) do
                          click_button invoice_btn_selector
                        end

                        in_browser(:org) { visit service_call_path service_call }
                      end

                      it 'should have a customer billing status as invoiced by subcon' do

                        should have_billing_status(I18n.t('activerecord.state_machines.service_call.billing_status.states.invoiced_by_subcon'))
                      end

                      it 'the provider should be able to collect the payment' do
                        in_browser(:org) do
                          should have_button paid_btn_selector
                        end
                      end

                      it 'should show an overdue button' do
                        should have_button payment_overdue_btn_selector
                      end

                      describe 'payment overdue' do

                        before do
                          click_button payment_overdue_btn_selector
                        end

                        it 'should show the billing status as overdue' do
                          should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.overdue'))
                        end

                        it 'should show the overdue event' do
                          should have_selector('table#event_log_in_service_call td', content: I18n.t('service_call_payment_overdue_event.description'))
                        end

                      end

                      describe 'subcontractor collects the payment' do

                        before { in_browser(:org2) { visit service_call_path(@subcon_service_call) } }

                        describe 'multi user organization subcontractor' do

                          it 'should have a collector select box with the technician as one of the values' do
                            @subcon_service_call.reload
                            should have_selector collector_select, content: @subcon_service_call.technician.name
                          end

                          it 'should not allow collection without specifying a collector' do
                            #page.driver.render("#{Rails.root}/tmp/capybara/before_collect_#{Time.now}.png", :full => true)
                            #page.save_page
                            click_button collect_btn_selector
                            should have_selector 'div.alert-error'
                          end

                          describe 'successful collection' do
                            before do
                              @subcon_service_call.reload
                              select @subcon_service_call.technician.name.rstrip, from: collector_select_selector
                              select Cash.model_name.human, from: JOB_SELECT_PAYMENT
                              click_button collect_btn_selector
                            end

                            it 'should mark as collected successfully when specifying a collector' do
                              should have_selector 'div.alert-success'
                            end

                            it 'should have an employee deposit button' do
                              should have_button employee_deposit_btn_selector
                            end

                            describe 'provider view' do
                              before do
                                in_browser(:org) { visit service_call_path(service_call) }
                              end

                              it 'the status should indicate the subcontractor has collected the payment' do
                                should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.collected_by_subcon'))

                              end

                              it " service call should have the collected event associated " do
                                service_call.reload
                                service_call.events.pluck(:reference_id).should include(100024)
                                should have_selector('table#event_log_in_service_call td', text: I18n.t('service_call_collected_event.description', subcontractor: service_call.subcontractor.name))
                              end

                            end

                            describe 'subcontractor deposits the payment' do

                              before do
                                click_button employee_deposit_btn_selector
                              end

                              it 'clicking deposit should update the billing status to claimed deposited' do
                                should have_billing_status(I18n.t('activerecord.state_machines.transferred_service_call.billing_status.states.collected'))
                              end

                              it 'should show the deposit to prov button' do
                                should have_button deposit_to_prov_btn_selector
                              end

                              describe 'successful deposit to provider' do
                                before do
                                  click_button deposit_to_prov_btn_selector
                                end

                                it 'should change the billing status to deposited' do
                                  should have_billing_status(I18n.t('activerecord.state_machines.transferred_service_call.billing_status.states.deposited_to_prov'))
                                end

                                it 'service call should have the deposit_to_prov event associated ' do
                                  @subcon_service_call.reload.events.pluck(:reference_id).should include(100022)
                                  should have_selector('table#event_log_in_service_call td', content: I18n.t('service_call_deposit_event.description', provider: @subcon_service_call.provider.name))
                                end

                                describe 'provider view' do
                                  before { in_browser(:org) { visit service_call_path(service_call) } }

                                  it 'billing status should be subcon claimed deposit' do
                                    should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.subcon_claim_deposited'))
                                  end

                                  it 'should have confirm deposited button' do
                                    should have_button confirm_deposit_btn_selector
                                  end

                                end

                                describe 'provider confirms deposit' do
                                  before do
                                    in_browser(:org) do
                                      visit service_call_path(service_call)
                                      click_button confirm_deposit_btn_selector
                                    end
                                  end

                                  it 'should show a success message' do
                                    should have_selector '.alert-success'
                                  end

                                  it 'should change the status to paid' do
                                    should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.paid'))
                                  end

                                  describe 'subcontractor view' do
                                    before do
                                      in_browser(:org2) do
                                        visit service_call_path(@subcon_service_call)
                                      end
                                    end

                                    it 'should show a billing status of deposit confirmed' do
                                      should have_billing_status(I18n.t('activerecord.state_machines.transferred_service_call.billing_status.states.deposited'))
                                    end


                                  end

                                end


                              end

                            end
                          end
                        end

                        describe 'single user organization subcontractor' do
                          before do
                            until org2.users.size == 1
                              org2.users.last.destroy
                            end
                            visit service_call_path(@subcon_service_call)
                          end

                          it 'should not display a collector select box' do
                            should_not have_selector collector_select
                          end

                          describe 'successful collection' do
                            before do
                              select Cash.model_name.human, from: JOB_SELECT_PAYMENT
                              click_button collect_btn_selector
                            end

                            it 'should mark as collected successfully' do
                              should have_selector 'div.alert-success'
                            end

                            describe 'provider view' do
                              before { in_browser(:org) { visit service_call_path(service_call) } }

                              it 'the status should indicate the subcontractor has collected the payment' do
                                should have_billing_status(I18n.t('activerecord.state_machines.my_service_call.billing_status.states.collected_by_subcon'))
                              end
                            end
                          end


                        end


                      end

                      describe 'the provider collects the payment' do

                        describe 'multi user provider organization' do
                          let!(:org_technician) { FactoryGirl.create(:technician, organization: org) }
                          before do
                            in_browser(:org) do
                              visit service_call_path(service_call)
                            end
                          end

                          it 'should show the collect button with a user select' do
                            should have_button collect_btn_selector
                            should have_select collector_select_selector
                          end

                          it 'should not allow to collect without specifying a user' do
                            click_button collect_btn_selector
                            should have_selector '.alert-error'
                          end


                          describe 'successful collection' do
                            before do
                              select org_technician.name, from: collector_select_selector
                              click_button collect_btn_selector
                            end

                            it 'should show a success flash' do
                              should have_selector 'div.alert-success'
                            end
                          end
                        end

                        describe 'single user provider organization' do
                          before do
                            in_browser(:org) do
                              visit service_call_path(service_call)
                              select Cash.model_name.human, from: JOB_SELECT_PAYMENT
                              click_button paid_btn_selector
                            end
                          end

                          it 'should show a success message' do
                            should have_selector '.alert-success'
                          end

                          describe 'subcontractor view' do
                            before do
                              in_browser(:org2) do
                                visit service_call_path(@subcon_service_call)
                              end
                            end

                            it 'should show a confirmed deposit status' do
                              should have_billing_status(I18n.t('activerecord.state_machines.transferred_service_call.billing_status.states.deposited'))
                            end
                          end
                        end

                      end
                    end

                    describe 'provider invoices the customer' do
                      before do
                        in_browser(:org) do
                          visit service_call_path service_call
                          click_button invoice_btn_selector
                        end
                      end

                      it "should have an invoiced billing status" do
                        should have_billing_status(I18n.t('activerecord.state_machines.service_call.billing_status.states.invoiced'))
                      end

                      it " service call should have the invoice event associated " do
                        service_call.events.pluck(:reference_id).should include(100018)
                        should have_selector('table#event_log_in_service_call td', text: I18n.t('service_call_invoice_event.description'))
                      end


                      describe "subcontractor view" do
                        before { in_browser(:org2) { visit service_call_path @subcon_service_call } }

                        it "should show invoiced by prov" do
                          should have_billing_status(I18n.t('activerecord.state_machines.service_call.billing_status.states.invoiced_by_prov'))
                        end

                        it " service call should have the provider invoiced event associated " do
                          @subcon_service_call.events.pluck(:reference_id).should include(100020)
                          should have_selector('table#event_log_in_service_call td', text: I18n.t('service_call_provider_invoiced_event.description', provider: @subcon_service_call.provider.name))
                        end


                      end
                    end

                  end
                end

                describe 'subcontractor is NOT expected to collect the payment' do

                  before do
                    service_call.allow_collection         = false
                    @subcon_service_call.allow_collection = false
                    service_call.save
                    @subcon_service_call.save
                  end

                  after do
                    @subcon_service_call.allow_collection = true
                    @subcon_service_call.save
                    service_call.allow_collection = true
                    service_call.save

                  end

                  describe "settlement initiated by subcontractor" do
                    before do

                      in_browser(:org2) do
                        visit service_call_path @subcon_service_call
                        click_button settle_btn_selector
                      end

                      in_browser(:org) { visit service_call_path service_call }
                    end

                    it 'should show subcon status as marked as settled' do

                      should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claimed_as_settled'))
                    end

                    describe 'subcontractor view' do
                      before { in_browser(:org2) {} }
                      it 'provider status should be claim_settled' do

                        should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.claim_settled'))
                      end
                    end

                    describe 'provider confirms settlement' do
                      before do
                        in_browser(:org) do
                          click_button confirm_settled_btn_selector
                        end
                      end

                      it 'subcontractor status should be settled' do

                        should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                      end


                      describe 'subcontractor view' do
                        before do
                          in_browser(:org2) do
                            visit service_call_path(@subcon_service_call)
                          end
                        end

                        it 'subcontractor status should be settled' do

                          should have_provider_status(I18n.t('activerecord.state_machines.transferred_service_call.provider_status.states.settled'))
                        end

                      end

                    end

                  end

                  describe 'settlement initiated by the provider' do
                    before do

                      in_browser(:org) do
                        visit service_call_path service_call
                        click_button settle_btn_selector
                      end
                    end

                    it 'should show subcon status as marked as claim_settled' do

                      should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.claim_settled'))
                    end


                  end
                end
              end
            end
          end
        end

        describe "subcontractor rejects the service call" do

          before do
            in_browser(:org2) do
              visit service_call_path @subcon_service_call
              click_button reject_btn_selector
            end

            in_browser(:org) { visit service_call_path service_call }
          end

          it "status remains transferred" do

            should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

          end

          it "work status changes to rejected" do

            should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.rejected'))
          end

          it " service call should have an rejected event associated " do
            service_call.events.pluck(:reference_id).should include(100012)
          end

          it 'transferred service call should have a reject event associated' do
            @subcon_service_call.events.pluck(:reference_id).should include(100011)
          end

        end

        describe "subcontractor transfers the service call to a local subcontractor" do
          let!(:local_subcontractor) do
            subcon                   = FactoryGirl.create(:subcontractor)
            subcon.subcontrax_member = false
            agr                      = setup_profit_split_agreement org2, subcon
            agr.counterparty
          end

          let(:second_service_call) { ServiceCall.find_by_organization_id_and_ref_id(local_subcontractor.id, @subcon_service_call.ref_id) }

          before do
            in_browser(:org2) do
              visit service_call_path @subcon_service_call
              click_button accept_btn_selector
              select local_subcontractor.name, from: subcontractor_select
              click_button transfer_btn_selector
            end
          end

          it "There should not be a service call for the local subcontractor" do
            second_service_call.should be_nil
          end

          it "should change the status to transferred localized" do
            should have_status(I18n.t('activerecord.state_machines.transferred_service_call.status.states.transferred'))
          end

          it "should show the subcontractor status with pending localized" do

            should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.pending'))
          end

          it "should show the subcontractor work action buttons" do
            Rails.logger.debug { "the subcon sc status is #{@subcon_service_call.status_name}" }
            Rails.logger.debug { "the subcon sc subcontractor is local? #{!@subcon_service_call.subcontractor.subcontrax_member?}" }
            should have_selector(accept_btn)
          end

        end

        describe "subcontractor transfers the service call to a member subcontractor" do
          let(:third_service_call) { ServiceCall.find_by_organization_id_and_ref_id(org3.id, @subcon_service_call.ref_id) }

          before do
            in_browser(:org2) do
              visit service_call_path @subcon_service_call
              click_button accept_btn_selector
              select org3.name, from: subcontractor_select

            end
            in_browser(:org3) do
              sign_in org_admin_user3
            end
          end


          it "created successfully" do
            expect do
              in_browser(:org2) do
                click_button transfer_btn_selector
              end
            end.to change(ServiceCall, :count).by(1)
          end

          describe "after transfer" do
            before do
              in_browser(:org2) do
                check re_transfer_cbox_selector
                click_button transfer_btn_selector
              end
            end
            it "should find the service call for the member subcontractor" do
              third_service_call.should_not be_nil
            end
            it "should change the status to passed" do
              in_browser(:org2) do

                should have_status(I18n.t('activerecord.state_machines.transferred_service_call.status.states.transferred'))
              end

            end

            it "should change the subcontractor status to pending localized" do
              in_browser(:org2) do

                should have_subcon_status(I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.pending'))
              end
            end

            describe "third transfer to the originator" do

              before do
                in_browser(:org3) do
                  visit service_call_path(third_service_call)
                  click_button accept_btn_selector
                  select org.name, from: subcontractor_select
                  click_button transfer_btn_selector
                  page.driver.render("#{Rails.root}/tmp/capybara/after_click_sc_#{Time.now}.png", :full => true)
                end
              end

              it "should not allow the transfer" do
                should have_selector '.alert-error', text: I18n.t('activerecord.errors.ticket.circular_transfer')
                #should have_text I18n.t('activerecord.errors.ticket.circular_transfer')

              end

            end

          end

        end

        describe "verify there is no access to the provider's customer" do
          before { visit service_call_path service_call }
        end

      end

      describe "transfer my service call to a local subcontractor" do
        let(:local_subcontractor) {
          subcon = FactoryGirl.create(:subcontractor)
          setup_profit_split_agreement(org, subcon).counterparty
        }
        before do
          Rails.logger.debug { "local subcontractor valid? #{local_subcontractor.valid?}" }
          visit service_call_path service_call
          select local_subcontractor.name, from: subcontractor_select
        end

        it "should not create another service call" do
          expect { click_button transfer_btn_selector }.to_not change(ServiceCall, :count)
        end


        describe 'successful transfer' do

          before do
            click_button transfer_btn_selector
          end

          it 'should show the accept button' do
            should have_button accept_btn_selector
          end

          it 'should change the status to transferred' do

            should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))
          end

          describe 'accept on behalf of the subcontractor' do
            before do
              click_button accept_btn_selector
            end

            it 'status should change to accepted' do
              should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.accepted'))
            end

            it 'should show the start button' do
              should have_button start_btn_selector
            end

            describe 'start the work on behalf of the subcontractor' do
              before do
                click_button start_btn_selector
              end

              it 'should change the work status to in progress' do

                should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.in_progress'))
              end

              it 'should show the complete buttong' do
                should have_button complete_btn_selector
              end

              describe 'mark the work as completed and add boms' do
                before do
                  add_bom "test part", 10.5, 22.5, 1
                  click_button complete_btn_selector
                end

                it 'should show the work status as completed' do
                  should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.done'))
                end

                it 'should show the settle button' do
                  should have_button settle_btn_selector
                end

                describe 'mark as settled' do
                  before do
                    click_button settle_btn_selector
                  end

                  it 'should change the subcontractor status to settled' do

                    should have_subcon_status(I18n.t('activerecord.state_machines.service_call.subcontractor_status.states.settled'))
                  end
                end
              end
            end
          end
        end


      end

      describe "dispatch the service call" do
        let!(:technician) { FactoryGirl.create(:technician, organization: org) }
        before do
          in_browser(:org) do
            visit service_call_path service_call
            select technician.name, from: technician_select
            click_button dispatch_btn_selector
            service_call.reload
          end

        end

        it " service call should have a dispatched event associated " do
          service_call.events.pluck(:reference_id).should include(100007)
        end


        describe "start the job" do
          before do
            click_button start_btn_selector
          end

          it "start time is set" do
            service_call.reload
            service_call.started_on.should_not be_nil
          end
          it "start time is displayed" do
            Time.parse(find(service_call_started_on).text) <= Time.current
          end

          it "work status should change to in progress" do
            should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.in_progress'))

          end
          it "subcontractor status should not be displayed" do

            should_not have_subcon_status('')
          end

          it " service call should have a started event associated " do
            service_call.events.pluck(:reference_id).should include(100015)
            should have_selector('table#event_log_in_service_call td', text: I18n.t('service_call_start_event.description', technician: service_call.technician.name))
            #service_call.events.where(reference_id: 100015).first.description.should eq(I18n.t('service_call_start_event.description', technician: service_call.technician.name))
          end


          describe "cancels the service call" do

            before do
              visit service_call_path service_call
              click_button cancel_btn_selector
            end

            it "should change the status to canceled" do

              should have_status(I18n.t('activerecord.state_machines.my_service_call.status.states.canceled'))

            end

            it 'service call should have a cancel event associated' do
              service_call.events.pluck(:reference_id).should include(100003)
            end

            it "should have canceled event displayed" do
              should have_selector("table#event_log_in_service_call td", content: I18n.t('service_call_cancel_event.description', user: service_call.updater.name.rstrip))
            end


          end


          describe "job done" do
            before do
              click_button complete_btn_selector
            end
            it "status should change to completed" do
              should have_work_status(I18n.t('activerecord.state_machines.service_call.work_status.states.done'))

            end
            it "subcontractor status should remain na" do
              should_not have_subcon_status('')

            end
            it "completion time is set" do
              service_call.reload
              service_call.completed_on.should_not be_nil
            end
            it "completion time is displayed" do
              Time.parse(find(service_call_completed_on).text) <= Time.current
            end

            it "should have a complete event associated " do
              service_call.events.pluck(:reference_id).should include(100005)
            end
            it "should have a complete event displayed " do
              Rails.logger.debug { "The event creator: '#{service_call.events.last.creator.name}'" }
              Rails.logger.debug { "The service_call updater: '#{service_call.updater.name}'" }
              Rails.logger.debug { "The event description: '#{service_call.events.last.description}'" }
              Rails.logger.debug { "The test description: '#{I18n.t('service_call_complete_event.description', user: service_call.updater.name)}'" }
              should have_selector('table#event_log_in_service_call td', text: I18n.t('service_call_complete_event.description', user: service_call.updater.name.rstrip))
            end


            describe "customer payment" do

              describe 'payment overdue' do

              end


            end


          end

          describe "job done" do
            pending
          end


        end


      end

      describe "edit service call page" do
        before { in_browser(:org) {} }
        describe "edit my service call" do
          let(:service_call) { FactoryGirl.create(:my_service_call, organization: org, customer: customer, subcontractor: nil, provider: org.becomes(Provider)) }
          let!(:technician) { FactoryGirl.create(:technician, organization: org) }
          before do
            visit edit_service_call_path service_call
          end

          it { should_not have_selector('error') }
          it "should have a subcontractor select box" do
            should have_selector("##{subcontractor_select}")

          end
          it "should have a provider select box" do
            should have_selector(provider_select)
          end
          it "should have a technician select box" do
            should have_selector("##{technician_select}")
          end
          it "should have a customer select box" do
            should have_selector("##{customer_select}")
          end

          describe "dispatch without a technician specified should show an error" do

            before do
              select I18n.t('activerecord.state_machines.service_call.work_status.states.dispatched'), from: work_status_select
              click_button save_btn_selector
            end

            it { should have_selector("div.error") }
          end


        end

        describe "edit transferred service call" do
          let(:service_call) { FactoryGirl.create(:my_service_call, organization: org, customer: customer, subcontractor: nil, provider: org.becomes(Provider)) }
          let(:transferred_service_call) do
            service_call.subcontractor = org2.becomes(Subcontractor)
            service_call.transfer
            ServiceCall.last
          end

          before do
            in_browser(:org2) do
              visit edit_service_call_path transferred_service_call
            end

          end
          it "should not allow to change the provider" do
            provider = FactoryGirl.build(:provider)
            org2.providers << provider

            in_browser(:org2) do
              put service_call_path transferred_service_call, service_call: { provider_id: provider.id }
            end

            transferred_service_call.provider_id.should_not == provider.id
            #page.should have_selector('.alert-error')

          end

        end

      end
    end

    describe "transferred service call from a local provider" do


      before do
        in_browser(:org) {
          visit new_service_call_path
          select provider.name, from: 'service_call_provider_id'
          fill_in new_customer_fld, with: customer.name
          click_button create_btn_selector

        }
      end

      it "should show the subcon accept button" do
        should have_button accept_btn_selector
      end

      describe "accept the service call" do
        before do
          click_button accept_btn_selector
        end

        it "should show a success message" do
          should have_selector('.alert-success')
        end

        describe "start the service call" do
          before do
            click_button start_btn_selector
          end

          it "should show a success message" do
            should have_selector('.alert-success')
          end


          describe "complete service call" do

            before do
              click_button complete_btn_selector
            end

            it "should show a success message" do
              should have_selector('.alert-success')
            end

            it "should show the provider invoice button" do
              should have_button provider_invoiced_btn_selector
            end

          end
        end
      end
    end


  end
end


