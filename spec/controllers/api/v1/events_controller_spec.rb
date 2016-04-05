require 'spec_helper'
load "#{Rails.root}/app/controllers/api/v1/events_controller.rb"

describe Api::V1::EventsController, :type => :controller do

  include_context 'transferred job'
  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job

    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in org.users.last

  end

  describe "GET index" do
    before do
      get :index, { eventable_id: job.id, eventable_type: 'Ticket', format: 'json' }
    end
    it 'returns http 200' do
      expect(response.status).to eq 200
    end

    it 'should return three events' do
      body          = JSON.parse(response.body)
      event_ref_ids = body.map { |e| e['reference_id'] }
      expect(event_ref_ids.sort).to eq [100002, 100016, 100017]
    end

  end

  describe 'GET show' do
    it 'assigns the requested event_id as @event' do
      event = Event.first
      get :show, { :id => event.to_param }
      assigns(:event).should eq(event)
    end
  end

end
