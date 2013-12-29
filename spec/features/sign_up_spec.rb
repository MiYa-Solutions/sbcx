require 'spec_helper'
require_relative '../../spec/features/sign_up_shared_stuff'

describe "Sign Up" do

  subject { page }

  before do
    visit new_user_registration_path
  end

  it 'page should show the industry select box' do
    expect(page).to have_select(SIGNUP_SELECT_INDUSTRY)
  end

end