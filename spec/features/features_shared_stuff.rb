require 'spec_helper'
require_relative '../../spec/features/sign_up_shared_stuff'


shared_context 'successful sign up' do
  before do
    visit new_user_registration_path unless URI.parse(current_url).path == new_user_registration_path

    fill_in SIGNUP_INPUT_EMAIL, with: 'signup_user@subcontrax.com'
    fill_in SIGNUP_INPUT_PASSWORD, with: '123456'
    fill_in SIGNUP_INPUT_PASSWORD_CONF, with: '123456'

    fill_in SIGNUP_INPUT_F_NAME, with: 'Signup Test'
    fill_in SIGNUP_INPUT_L_NAME, with: 'User'
    fill_in SIGNUP_INPUT_PHONE, with: '212-222-2222'
    fill_in SIGNUP_INPUT_MOBILE, with: '917-917-9317'
    fill_in SIGNUP_INPUT_WORK_PHONE, with: '917-917-9317'

    fill_in SIGNUP_INPUT_ORG_NAME, with: 'Signup Test Org'
    select 'Locksmith', from: SIGNUP_SELECT_INDUSTRY
    fill_in SIGNUP_INPUT_ORG_ADD1, with: 'Signup Test Org Address1'
    fill_in SIGNUP_INPUT_ORG_ADD2, with: 'Signup Test Org Address2'
    fill_in SIGNUP_INPUT_ORG_CITY, with: 'New York'
    first("##{SIGNUP_SELECT_COUNTRY} option").click
    #select option, from: SIGNUP_SELECT_COUNTRY
    select 'New York', from: SIGNUP_SELECT_STATE
    fill_in SIGNUP_INPUT_ORG_ZIP, with: '10000'
    fill_in SIGNUP_INPUT_ORG_WEBSITE, with: 'www.signuptest.abc'
    fill_in SIGNUP_INPUT_ORG_PHONE, with: '917-917-9317'
    fill_in SIGNUP_INPUT_ORG_MOBILE, with: '917-917-9317'
    fill_in SIGNUP_INPUT_ORG_EMAIL, with: 'signup_user@subcontrax.com'

    click_button SIGNUP_BTN_SIGN_UP unless example.metadata[:skip_sign_up_btn]
  end

  it 'should show a success message' do
    expect(page).to have_success_message
  end

end