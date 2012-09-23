require 'spec_helper'
require 'capybara/rspec'

describe "Service Call pages" do


  describe "with Org Admin" do

    let(:org_admin_user) { FactoryGirl.create(:org_admin) }
    let(:org_admin_user2) { FactoryGirl.create(:org_admin) }
    let(:org) { org_admin_user.organization }
    let(:org2) { org_admin_user2.organization }

    let(:provider) {
      prov = FactoryGirl.create(:provider)
      org.providers << prov
      prov
    }

    let(:subcontractor) {
      subcontractor = org2.becomes(Subcontractor)
      org.subcontractors << subcontractor
      subcontractor
    }

    let(:customer) { FactoryGirl.create(:customer, organization: org) }

    before(:each) do
      in_browser(:org) do
        sign_in org_admin_user
      end

      in_browser(:org2) do
        sign_in org_admin_user2
      end


    end

    subject { page }

    describe "new service call page" do
      before do
        provider.save!
        customer.save!
        in_browser(:org) do
          with_user(org_admin_user) do
            visit new_service_call_path
          end
        end

      end
      in_browser(:org) do
        it { should have_selector('#service_call_started_on_text') }
      end


      it "should be created successfully" do
        in_browser(:org) do
          expect do
            select provider.name, from: 'service_call_provider_id'
            select customer.name, from: 'service_call_customer_id'
            click_button 'service_call_create_btn'
          end.to change(ServiceCall, :count).by(1)
        end


      end


    end

    describe "show service call" do
      let!(:service_call) { FactoryGirl.create(:service_call, organization: org, customer: customer, provider: provider) }

      before do
        subcontractor.save
        visit service_call_path service_call
      end

      it { should have_button('service_call_transfer_btn') }

      describe "transfer service call" do
        before do
          select subcontractor.name, from: 'service_call_subcontractor'
          click_button 'service_call_transfer_btn'
        end

        it "should change the status to open" do
          should have_selector('#service_call_status', text: ServiceCall.human_status_name(:open).titleize)
        end

        it "should show up in the subcontractors gui" do
          in_browser(:org2) do
            visit service_calls_path
            should have_selector('h1', text: 'Service Calls')
            should have_content(customer.name)
          end


        end
      end

    end


  end

end
