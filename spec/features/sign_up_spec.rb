require 'spec_helper'
require_relative '../../spec/features/sign_up_shared_stuff'
require_relative '../../spec/features/features_shared_stuff'

describe "Sign Up" do

  subject { page }

  before do
    visit new_user_registration_path
  end

  it 'page should show the industry select box' do
    expect(page).to have_select(SIGNUP_SELECT_INDUSTRY)
  end

  context 'when selecting other industry', js: true do
    before do
      select 'Other', from: SIGNUP_SELECT_INDUSTRY
    end

    it 'should show the other industry check box' do
      expect(page).to have_selector("##{SIGNUP_INPUT_OTHER_INDUSTRY}")
    end
  end

  context 'when successfull' do
    include_context 'successful sign up'
  end

end