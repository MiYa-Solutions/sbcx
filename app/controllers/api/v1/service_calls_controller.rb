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
    respond_to do |format|

      if @service_call.update_attributes(service_call_params)
        format.json { render json: @service_call, status: :ok }
      else
        format.json { render json: { errors: @service_call.errors }, status: :unprocessable_entity }
      end
    end
  end

  protected
  def load_service_call
    if params[:use_external_ref]
      @service_call = ServiceCall.where(organization_id: current_user.organization_id, external_ref: params[:id]).first
    else
      @service_call = ServiceCall.where(organization_id: current_user.organization_id, id: params[:id]).first
    end
  end

  private

  def service_call_params
    params.require(:service_call).permit(:tag_list, :started_on_text)
  end

end
