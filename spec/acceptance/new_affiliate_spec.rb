require 'spec_helper'

describe 'New Affiliate', js: true do

  let(:sign_up_page) { SignUpPage.new }
  let(:new_affiliate_page) { NewAffiliatePage.new }

  before do
    sign_up_page.load
    sign_up_page.sign_up
    new_affiliate_page.load
  end

  it 'should have the email field' do
    expect(new_affiliate_page).to have_email
  end

  context 'successful affiliate creation' do
    before do
      new_affiliate_page.create_affiliate
    end
    it 'should show a success message' do
      expect(new_affiliate_page).to have_notice_flash
    end
    it 'should show affiliate page' do
      expect(AffiliatePage.new).to be_displayed
    end
  end

  context 'validation error ' do
    before do
      new_affiliate_page.create_affiliate name: ''
    end
    it 'should show an error message' do
      expect(new_affiliate_page).to have_error_flash
    end
  end



end
