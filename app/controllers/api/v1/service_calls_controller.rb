class Api::V1::ServiceCallsController < Api::V1::ApiController
  filter_resource_access context: :service_calls

  # GET /api/v1/jobs
  # GET /api/v1/jobs.json
  def index
    @service_calls = current_user.organization.tickets

    respond_to do |format|
      format.json { render json: @service_calls }
    end
  end

  # GET /api/v1/jobs/1
  # GET /api/v1/jobs/1.json
  def show
    respond_to do |format|
      format.json { render json: @service_call }
    end
  end

  def update
    if @service_call.update_attributes(service_call_params)
      respond_with @service_call
    else
      respond_with json: {}, status: :unprocessable_entity
    end
  end

  protected
  def load_service_call
    #@service_call = Ticket.find(params[:id])
    if params[:use_external_ref]
      @service_call = ServiceCall.find_by_external_ref(params[:id])
    else
      @service_call = ServiceCall.find(params[:id])
    end
  end

  private

  def service_call_params
    params.require(:service_call).permit(:tag_list)
  end

end
