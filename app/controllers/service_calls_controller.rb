class ServiceCallsController < ApplicationController
  before_filter :authenticate_user!
  filter_access_to :autocomplete_customer_name, :require => :index
  filter_resource_access

  autocomplete :customer, :name, extra_data: [:address1, :address2, :company, :phone, :email, :mobile_phone, :work_phone, :country, :state, :city, :zip], full: true, limit: 50

  def index
    @service_calls = ServiceCall.jobs_to_work_on(current_user.organization).all(order: 'id DESC')
    @transferred_jobs = ServiceCall.my_transferred_jobs(current_user.organization).all(order: 'id DESC')

    respond_to do |format|
      format.html {}

      format.json { render json: TicketsDatatable.new(view_context) }
    end

  end

  def show
    #@service_call = ServiceCall.find(params[:id])
    @customer = Customer.new
    @bom      = Bom.new
  end

  def new
    @service_call = ServiceCall.new
    @customer     = Customer.new
    store_location
  end

  def create
    if @service_call.save
      flash[:success] = t('service_call.crud_messages.success')
      redirect_to service_call_path @service_call
    else
      render :action => 'new'
    end
  end

  def edit
    # no need for the below line as filter_resource_access before filter takes care of that
    #@service_call = ServiceCall.find(params[:id])
  end

  def update

    if @service_call.update_attributes(permitted_params(@service_call).service_call)
      respond_to do |format|
        format.js {}
        format.html do
          flash[:success] = t('service_call.crud_messages.update.success')
          redirect_to service_call_path @service_call
        end
        format.mobile do
          flash[:success] = t('service_call.crud_messages.update.success')
          redirect_to service_call_path @service_call
        end

        #format.json { respond_with_bip @service_call }
        format.json { render :json => @service_call, status: :ok }
      end
    else
      respond_to do |format|
        format.js { respond_bip_error @service_call }
        format.html do
          render :action => 'show'
        end
        format.json { respond_bip_error @service_call }

      end


    end
  end


  def new_service_call_from_params
    @service_call ||= ServiceCall.new_from_params(current_user.organization, permitted_params(nil).service_call)
  end

  def load_service_call
    @service_call = Ticket.find(params[:id])
  end

  # TODO move autocomplete to CustomerController
  def autocomplete_customer_name_where
    Rails.logger.debug { "Invoked #{self.class.name}#autocomplete_customer_name_where" }
    default = "organization_id = #{current_user.organization.id}"

    if params[:ref_id].nil? || params[:ref_id].blank?
      return default
    else
      org = Organization.find(params[:ref_id])
      # verify that the organization requested is not a member and that it is part of my subcontractors
      unless org.subcontrax_member? || !current_user.organization.one_of_my_local_providers?(org.id)
        return "organization_id = #{org.id}"
      end

      return "organization_id = -1" # force a blank result
    end

  end

end

