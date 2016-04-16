require "spec_helper"

describe Api::V1::EventsController do
  describe 'routing' do

    it 'routes to #index' do
      get('/api/v1/events').should route_to('api/v1/events#index')
    end

    it 'routes to #show' do
      get('/api/v1/events/1').should route_to('api/v1/events#show', :id => '1')
    end

  end
end
