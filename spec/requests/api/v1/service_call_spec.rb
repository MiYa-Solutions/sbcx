require 'spec_helper'
load "#{Rails.root}/app/controllers/api/v1/api_controller.rb"
load "#{Rails.root}/app/controllers/api/v1/service_calls_controller.rb"

describe 'Service Call V1 API' do

  include_context 'transferred job'
  include_context 'api'

  let(:user_token) { user.reload.authentication_token }

  before do
    user.save!
    job.save!
    api_sign_in user
  end


  describe 'GET service_calls' do
    before do
      get 'api/v1/service_calls',
          { format: :json },
          { 'Content-Type' => 'application/json',
            'X-User-Token' => user_token,
            'X-User-Email' => user.email,
            'Accept'       => 'application/json' }
    end

    it 'should return HTTP 200' do
      expect(response.status).to eq 200
    end

    it 'response body should be a JSON in the Datatables format' do
      body = JSON.parse(response.body)
      expect(body['aaData']).to_not be_nil
      expect(body['aaData'].size).to eq 1
      expect(body['iTotalRecords']).to eq 1
      expect(body['iTotalDisplayRecords']).to eq 1
    end


  end

  describe 'GET service_calls/:external_ref' do
    before do
      get "api/v1/service_calls/#{job.external_ref}",
          { format: :json, use_external_ref: '' },
          { 'Content-Type' => 'application/json',
            'X-User-Token' => user_token,
            'X-User-Email' => user.email,
            'Accept'       => 'application/json' }
    end

    it 'should return HTTP 200' do
      expect(response.status).to eq 200
    end

    it 'response body should be a JSON with the job information' do
      body = JSON.parse(response.body)
      expect(body['external_ref']).to eq job.external_ref
    end


  end

  describe 'GET service_calls/:id' do
    before do
      get "api/v1/service_calls/#{job.id}",
          { format: :json },
          { 'Content-Type' => 'application/json',
            'X-User-Token' => user_token,
            'X-User-Email' => user.email,
            'Accept'       => 'application/json' }
    end

    it 'should return HTTP 200' do
      expect(response.status).to eq 200
    end

    it 'response body should be a JSON with the job information' do
      body = JSON.parse(response.body)
      expect(body['external_ref']).to eq job.external_ref
    end


  end

  describe 'PUT service_calls/:external_ref' do

    describe 'tags are created' do
      before do
        put "api/v1/service_calls/#{job.external_ref}",
            { format: :json, use_external_ref: '', service_call: { tag_list: 'TEST1, TEST2' } },
            { 'Content-Type' => 'application/json',
              'X-User-Token' => user_token,
              'X-User-Email' => user.email,
              'Accept'       => 'application/json' }
      end

      it 'should return HTTP 200' do
        expect(response.status).to eq 200
      end


      it 'the job should have the new tags set' do
        expect(job.reload.tag_list).to eq 'TEST2, TEST1'
      end
    end
  end

end