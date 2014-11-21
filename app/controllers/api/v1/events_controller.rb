class Api::V1::EventsController < ApplicationController
  before_filter :authenticate_user!

  # GET /api/v1/events
  # GET /api/v1/events.json
  def index
    @events = Event.find_all_by_eventable_id_and_eventable_type(params[:eventable_id], params[:eventable_type])

    respond_to do |format|
      format.json { render json: @events }
    end
  end

  # GET /api/v1/events/1
  # GET /api/v1/events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.json { render json: @event }
    end
  end
end
