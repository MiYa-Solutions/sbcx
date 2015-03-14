require 'spec_helper'

describe 'New Job', js: true do

  let(:sign_up_page) { SignUpPage.new }
  let(:new_job_page) { NewJobPage.new }
  let(:new_customer_page) { NewCustomerPage.new }
  let(:new_affiliate_page) { NewAffiliatePage.new }
  let(:job_page) { JobPage.new }

  before do
    sign_up_page.load
    sign_up_page.sign_up
    new_customer_page.load
    new_customer_page.create_customer name: 'Test Customer', address1: 'Test Cus Address1'
    new_job_page.load
  end

  it 'should have the email field' do
    expect(new_job_page).to have_email
  end

  it 'should have the a provider select field' do
    expect(new_job_page).to have_provider_select
  end

  context 'successful job creation' do
    before do
      new_job_page.create_job customer_search: 'Test', customer_name: 'Test Customer', address1: 'Changed Address 1'
    end

    it 'should show a success message' do
      expect(new_job_page).to have_success_flash
    end

    it 'should show job page' do
      expect(job_page).to be_displayed
    end

    it 'job page should show the changed address' do
      job_page.show_info
      expect(job_page.address1.text).to eq 'Changed Address 1'
    end

    it 'selected customer is set' do
      expect(job_page.customer_name.text).to eq 'Test Customer'
    end
  end

  context 'when selecting the customer' do
    before do
      new_job_page.fill_in_autocomplete(new_job_page.customer_quick_select, 'Test', select: 'Test Customer')
    end

    it 'address1 should have the customer address1' do
      new_job_page.wait_for_address1
      expect(new_job_page.address1.value).to eq 'Test Cus Address1'
    end
  end

  context 'when specifying a new none existent customer' do
    before do
      new_job_page.create_job customer_search: 'New Customer', customer_name: 'New Customer'
    end
    it 'should show an success message' do
      expect(job_page).to have_success_flash
    end
  end

  context 'when no customer is specified' do
    before do
      new_job_page.create_job customer_search: '', customer_name: ''
    end
    it 'should show an error message' do
      expect(new_job_page).to have_error_flash
    end
  end

  context 'when creating a transferred job' do
    before do
      new_affiliate_page.load
      new_affiliate_page.create_affiliate name: 'Test Provider'
      new_job_page.load
      new_job_page.create_job customer_search: 'Test', customer_name: 'Test Customer', provider_name: 'Test Provider'
    end

    it 'should show job page' do
      expect(job_page).to be_displayed
    end


    it 'should show an success message' do
      expect(job_page).to have_success_flash
    end

    it 'should have a Received New status' do
      expect(job_page.status.text).to eq 'Received New'
    end


  end


end
