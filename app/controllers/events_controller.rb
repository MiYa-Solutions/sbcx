class EventsController < ApplicationController
  before_filter :authenticate_user!
  # GET /events
  # GET /events.json
  def index

    respond_to do |format|
      format.json { render json: EventsDatatable.new(self).as_json }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

end
