require 'spec_helper'
require 'rest_client'

describe 'Event JSON API Spec' do

  include_context 'transferred job'

  before do
    # SignUpPage.sign_up
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job

    # response_json = post user_session_path,
    #                      { :user => { :email    => org_admin.email,
    #                                   :password => "foobar" } },
    #                      :content_type => :json, :accept => :json
    #
    # response      = ActiveSupport::JSON.decode(response_json)
    # response["response"].should == "ok"
    # # response["user"].should == @user.as_json
    # @@token = response["token"]
    # @@token.should_not == nil
  end

  describe 'GET /events for the provider job' do
    before do
      # sign_in org_admin
      get "/api/v1/events", { eventable_id: job.id, eventable_type: 'Ticket' }, { "Accept" => "application/json" }
    end

    it 'request should be successful' do
      expect(response.status).to eq 200
    end

    it 'should return three events' do
      body          = JSON.parse(response.body)
      event_ref_ids = body.map { |e| e[:reference_id] }
      expect(event_ref_ids.sort).to eq ['100002', '100016', '100017']
    end
  end
end