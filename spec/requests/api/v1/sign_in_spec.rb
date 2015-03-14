require 'spec_helper'
load "#{Rails.root}/app/controllers/api/v1/sessions_controller.rb"


describe 'Sign In V1' do

  include_context 'basic job testing'
  include_context 'api'

  let(:token) {user.reload.authentication_token}

  before do
    # org.save!
    # user.save!
    api_sign_in user
  end

  it 'response should be successful' do
    expect(response.status).to eq 200
  end

  it 'expect response to include security token' do
    body = JSON.parse(response.body)
    expect(body['authentication_token']).to eq token
  end
end