class Api::V1::JobsController < Api::V1::ApiController

  # GET /api/v1/jobs
  # GET /api/v1/jobs.json
  def index
    @jobs = current_user.organization.tickets

    respond_to do |format|
      format.json { render json: @jobs }
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
