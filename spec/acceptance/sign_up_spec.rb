require 'spec_helper'

describe 'Sign up', js: true do

  let(:sign_up_page) { SignUpPage.new }

  before do
    sign_up_page.load
  end

  it 'the page should be displayed' do
    expect(sign_up_page).to be_displayed
  end

  it 'should have user email field' do
    expect(sign_up_page).to have_email
  end

  it 'should have sign up button' do
    expect(sign_up_page).to have_sign_up_btn
  end

  context 'when user clicks on the sign up link in the index' do
    before do
      sign_up_page.sign_up
    end

    it ' should show an error message' do
      expect(sign_up_page).to have_success_flash
    end

  end

  context 'when user clicks on the sign up link but no email' do
    before do
      sign_up_page.sign_up email: 'invalid_email'
    end

    it ' should show an error message' do
      expect(sign_up_page).to have_error_flash
    end

  end

  context 'when user clicks on the sign up link but no industry' do
    before do
      sign_up_page.sign_up industry: ''
    end

    it ' should show an error message' do
      expect(sign_up_page).to have_error_flash
    end

  end

  context 'when user select other industry' do
    before do
      sign_up_page.industry_select.select('Other')
      sign_up_page.wait_for_other_industry
    end

    it 'should display other industry' do
      expect(sign_up_page).to have_other_industry
    end
  end

end
