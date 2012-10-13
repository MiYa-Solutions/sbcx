require 'spec_helper'
require 'capybara/rspec'

describe "Service Call pages" do

  # ==============================================================
  # data elements to inspect
  # ==============================================================
  status                    = 'span#service_call_status'
  subcontractor_status      = 'span#service_call_subcontractor_status'
  billing_status            = 'span#service_call_billing_status'
  service_call_started_on   = '#service_call_started_on_text'
  service_call_completed_on = '#service_call_completed_on_text'
  subcontractor_select      = 'service_call_subcontractor_id'
  provider_select           = 'service_call_provider_id'
  technician_select         = 'service_call_technician_id'
  status_select             = 'service_call_status_event'
  customer_select           = 'service_call_customer_id'
  new_customer_fld          = 'service_call_new_customer'

  # ==============================================================
  # buttons to click and inspect
  # ==============================================================
  transfer_btn              = '#service_call_transfer_btn'
  transfer_btn_selector     = 'service_call_transfer_btn'
  dispatch_btn              = '#service_call_dispatch_btn'
  dispatch_btn_selector     = 'service_call_dispatch_btn'
  create_btn                = 'service_call_create_btn'
  create_btn_selector       = 'service_call_create_btn'
  accept_btn                = '#accept_service_call_btn'
  accept_btn_selector       = 'accept_service_call_btn'
  reject_btn                = '#reject_service_call_btn'
  reject_btn_selector       = 'reject_service_call_btn'
  settle_btn                = '#settle_service_call_btn'
  settle_btn_selector       = 'settle_service_call_btn'
  start_btn                 = '#start_service_call_btn'
  start_btn_selector        = 'start_service_call_btn'
  complete_btn              = '#complete_service_call_btn'
  complete_btn_selector     = 'complete_service_call_btn'
  paid_btn                  = '#paid_service_call_btn'
  paid_btn_selector         = 'paid_service_call_btn'
  save_btn                  = '#service_call_save_btn'
  save_btn_selector         = 'service_call_save_btn'


  describe "with Org Admin" do

    let(:org_admin_user) { FactoryGirl.create(:member_admin) }
    let(:org_admin_user2) { FactoryGirl.create(:member_admin) }
    let(:org) { org_admin_user.organization }
    let(:org2) { org_admin_user2.organization }

    let(:provider) {
      prov = FactoryGirl.create(:provider)
      org.providers << prov
      org.save!
      prov
    }

    let(:subcontractor) {
      subcontractor = org2.becomes(Subcontractor)
      org.subcontractors << subcontractor
      subcontractor
    }

    let(:customer) { FactoryGirl.create(:customer, organization: org) }

    before do
      org.providers << org2.becomes(Provider)
      in_browser(:org) do
        sign_in org_admin_user
      end

      in_browser(:org2) do
        sign_in org_admin_user2
      end


    end

    subject { page }

    describe "new service call page" do

      #initialize orgs provider, customer, etc.
      before do
        provider.save!
        customer.save!
        in_browser(:org) do
          with_user(org_admin_user) do
            visit new_service_call_path
          end
        end

      end


      it "should have a started on label" do
        in_browser(:org) do
          should have_selector(service_call_started_on)
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
              select customer.name, from: 'service_call_customer_id'
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
            org.providers << provider
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
            select customer.name, from: 'service_call_customer_id'
          end
        end


        it "should be created successfully" do
          expect do
            click_button create_btn
          end.to change(ServiceCall, :count).by(1)
        end

        let(:service_call) { ServiceCall.last }

        it "should be of type MyServiceCall" do
          expect { service_call.should be_a_kind_of(MyServiceCall) }
        end

      end


    end


    describe "show service call" do
      let(:service_call) { FactoryGirl.create(:my_service_call, organization: org, customer: customer, subcontractor: nil) }

      before do
        subcontractor.save
        in_browser(:org) do
          visit service_call_path service_call
        end

      end
      it { should have_selector(transfer_btn, value: I18n.t('activerecord.state_machines.my_service_call.status.events.transfer')) }

      it { should have_selector(status) }

      describe "multi user organization" do

        let!(:technician) { FactoryGirl.create(:technician, organization: org) }

        before do
          visit service_call_path service_call
        end

        it { should have_selector(dispatch_btn, value: I18n.t('activerecord.state_machines.my_service_call.status.events.dispatch')) }

      end

      describe "transfer my service call to a member subcontractor" do
        # transfer the service call
        before do
          in_browser(:org) do
            select subcontractor.name, from: subcontractor_select
            click_button transfer_btn_selector
          end
          @subcon_service_call = ServiceCall.find_by_organization_id_and_ref_id(subcontractor.id, service_call.ref_id)
        end

        it "should change the status to transferred localized" do
          should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))
        end

        it "should change the subcontractor status to pending localized" do
          should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.pending'))
        end

        describe "subcontractor browser" do
          let(:subcon_service_call) { ServiceCall.find_by_organization_id_and_ref_id(subcontractor.id, service_call.ref_id) }

          before(:each) do
            in_browser(:org2) do
              visit service_call_path subcon_service_call
            end


          end

          it "should show up in the subcontractors gui with a locelized received_new status" do
            should have_selector(status, text: I18n.t('activerecord.state_machines.transferred_service_call.status.states.received_new'))
          end

          it "should have a subcontractor status with localized na" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.na'))
          end

          it "should have the right provider " do
            should have_selector('#provider', text: org.name)
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
            should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

          end
          it "subcontractor status changes to accepted" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.accepted'))
          end

          it { should have_selector(settle_btn, value: I18n.t('activerecord.state_machines.my_service_call.status.events.transfer')) }


          describe "subcontractor browser" do
            before { in_browser(:org2) { } }

            it " status changed to accepted" do
              should have_selector(status, text: I18n.t('activerecord.state_machines.transferred_service_call.status.states.accepted'))
            end

            it " subcontractor status remains na" do
              should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.na'))
            end

          end

          describe "subcontractor dispatches the service call" do
            let!(:technician) { FactoryGirl.create(:technician, organization: subcontractor) }
            before do
              in_browser(:org2) do
                visit service_call_path @subcon_service_call
                # todo implement technician scope in Organization
                select technician.name, from: technician_select
                click_button dispatch_btn_selector
              end

              in_browser(:org) { visit service_call_path service_call }
            end

            it "status remains transferred" do
              should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

            end
            it "subcontractor status changes to in progress" do
              should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.in_progress'))
            end

            describe "subcontractor view after dispatch" do
              before { in_browser(:org2) { } }
              it "status should change to dispatched" do
                should have_selector(status, text: I18n.t('activerecord.state_machines.transferred_service_call.status.states.dispatched'))

              end
              it "subcontractor status should remain na" do
                should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.na'))

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
                should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

              end
              it "subcontractor status remains in progress" do
                should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.in_progress'))
              end
              it "start time is set" do
                Time.parse(find(service_call_started_on).text) <= Time.current
              end

              describe "subcontractor view after start" do
                before { in_browser(:org2) { } }
                it "status should change to in progress" do
                  should have_selector(status, text: I18n.t('activerecord.state_machines.transferred_service_call.status.states.in_progress'))

                end
                it "subcontractor status should remain na" do
                  should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.na'))

                end

                it "start date should be updated with the current time" do
                  Time.parse(find(service_call_started_on).text) <= Time.current
                end


              end

              describe "subcontractor completes the service call" do
                before do
                  in_browser(:org2) do
                    visit service_call_path @subcon_service_call
                    click_button complete_btn_selector
                  end

                  in_browser(:org) { visit service_call_path service_call }
                end

                it "status remains transferred" do
                  should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

                end
                it "subcontractor status changes to completed" do
                  should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.work_done'))
                end
                it "completion time is set" do
                  Time.parse(find(service_call_completed_on).text) <= Time.current
                end

                describe "subcontractor view after complete" do
                  before { in_browser(:org2) { } }
                  it "status should change to completed" do
                    should have_selector(status, text: I18n.t('activerecord.state_machines.transferred_service_call.status.states.work_done'))

                  end
                  it "subcontractor status should remain na" do
                    should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.na'))

                  end

                  it "completed date should be updated with the current time" do
                    Time.parse(find(service_call_completed_on).text) <= Time.current
                  end


                end

                describe "subcontractor settles with the provider" do
                  before do
                    in_browser(:org2) do
                      visit service_call_path @subcon_service_call
                      click_button settle_btn_selector
                    end

                    in_browser(:org) { visit service_call_path service_call }
                  end

                  # transferred is considered open
                  it "status remains transferred" do
                    should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

                  end
                  it "subcontractor status changes to settled" do
                    should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.settled'))
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
            should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

          end
          it "subcontractor status changes to rejected" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.rejected'))
          end
        end

        describe "subcontractor transfers the service call to a local subcontractor" do
          let(:local_subcontractor) { FactoryGirl.create(:subcontractor) }

          let(:second_service_call) { ServiceCall.find_by_organization_id_and_ref_id(local_subcontractor.id, @subcon_service_call.ref_id) }

          before do
            org2.subcontractors << local_subcontractor
            in_browser(:org2) do
              visit service_call_path @subcon_service_call
              select local_subcontractor.name, from: subcontractor_select
              click_button transfer_btn_selector

            end
          end

          it "should NOT find the service call for the local subcontractor" do
            second_service_call.should be_nil
          end

          it "should change the status to transferred localized" do
            should have_selector(status, text: I18n.t('activerecord.state_machines.transferred_service_call.status.states.transferred'))
          end

          it "should change the subcontractor status to pending localized" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.pending'))
          end

        end

        describe "subcontractor transfers the service call to a member subcontractor" do
          pending
        end

        describe "verify there is no access to the provider's customer" do
          before { visit service_call_path service_call }
        end

      end

      describe "transfer my service call to a local subcontractor" do
        let(:local_subcontractor) { FactoryGirl.create(:subcontractor) }
        before do
          org.subcontractors << local_subcontractor
          visit service_call_path service_call
          select local_subcontractor.name, from: subcontractor_select
        end

        it "should not create another service call" do
          expect { click_button transfer_btn_selector }.to_not change(ServiceCall, :count)
        end


      end

      describe "dispatch the service call" do
        let!(:technician) { FactoryGirl.create(:technician, organization: org) }
        before do
          in_browser(:org) do
            visit service_call_path service_call
            # todo implement technician scope in Organization
            select technician.name, from: technician_select
            click_button dispatch_btn_selector
          end

        end

        it "status should change to dispatched" do
          should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.dispatched'))

        end
        it "subcontractor status should remain na" do
          should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.na'))

        end


        describe "start the job" do
          before do
            click_button start_btn_selector
          end

          it "start time is set" do
            Time.parse(find(service_call_started_on).text) <= Time.current
          end

          it "status should change to dispatched" do
            should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.in_progress'))

          end
          it "subcontractor status should remain na" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.na'))

          end

          describe "job done" do
            before do
              click_button complete_btn_selector
            end
            it "status should change to completed" do
              should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.work_done'))

            end
            it "subcontractor status should remain na" do
              should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.na'))

            end
            it "completion time is set" do
              Time.parse(find(service_call_completed_on).text) <= Time.current
            end

            describe "customer paid" do
              before do
                fill_in 'service_call_total_price', with: '100'
                click_button paid_btn_selector
              end

              it "status should change to closed" do
                should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.closed'))
              end

              it "customer status should change to paid" do
                should have_selector(billing_status, text: I18n.t('activerecord.state_machines.service_call.billing_status.states.paid'))
              end
            end

          end


        end

        describe "job done" do

        end


      end

      describe "with single user organization" do

        it "should show start instead of dispatch" do
          should have_selector(start_btn)
        end

        it "should not show dispatch" do
          should_not have_selector(dispatch_btn)
        end
      end

    end

    describe "edit service call page" do
      before { in_browser(:org) { } }
      describe "edit my service call" do
        let(:service_call) { FactoryGirl.create(:my_service_call, organization: org, customer: customer, subcontractor: nil, provider: org.becomes(Provider)) }

        before do
          visit edit_service_call_path service_call
        end

        it { should_not have_selector('error') }
        it "should have a subcontractor select box" do
          should have_selector("##{subcontractor_select}")

        end
        it "should have a provider select box" do
          should have_selector("##{provider_select}")
        end
        it "should have a technician select box" do
          should have_selector("##{technician_select}")
        end
        it "should have a customer select box" do
          should have_selector("##{customer_select}")
        end

        describe "dispatch without a technician specified should show an error" do
          before do
            select I18n.t('activerecord.state_machines.my_service_call.status.states.dispatched'), from: status_select
            click_button save_btn_selector
          end

          it { should have_selector("div.error") }
        end


      end

      describe "edit transferred service call" do
        pending
      end
    end


  end

end
