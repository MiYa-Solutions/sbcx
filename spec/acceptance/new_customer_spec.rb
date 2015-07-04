require 'spec_helper'

describe 'New Customer' do
  let(:sign_up_page) { SignUpPage.new }
  let(:new_customer_page) { NewCustomerPage.new }

  before do
    sign_up_page.load
    sign_up_page.sign_up
    new_customer_page.load
  end

  it 'should have the email field' do
    expect(new_customer_page).to have_email
  end

  it 'should have the name field' do
    expect(new_customer_page).to have_name
  end

  context 'successful affiliate creation' do
    before do
      new_customer_page.create_customer
    end
    it 'should show a success message' do
      expect(new_customer_page).to have_success_flash
    end
    it 'should show affiliate page' do
      expect(CustomerPage.new).to be_displayed
    end
  end

  context 'validation error ' do
    before do
      new_customer_page.create_customer name: ''
    end

    it 'should show an error message next to the name field' do
      expect(new_customer_page.name_validation).to_not be_nil
      expect(new_customer_page.name_validation.text).to eq "can't be blank"
    end
  end


end
