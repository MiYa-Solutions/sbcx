require 'spec_helper'

describe EventsController, type: :controller do
  include_context 'transferred job'
  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job

    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in org.users.last
  end
  describe "GET /events" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get :index, { eventable_id: job.id, eventable_type: 'Ticket', format: 'json' }
      response.status.should be(200)
    end
  end
end
