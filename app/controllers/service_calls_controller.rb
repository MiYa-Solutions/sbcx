class ServiceCallsController < ApplicationController
  before_filter :authenticate_user!
  filter_access_to :autocomplete_customer_name, :require => :index
  filter_resource_access

  autocomplete :customer, :name, extra_data: [:address1, :address2, :company, :phone, :email, :mobile_phone, :work_phone, :country, :state, :city, :zip], full: true, limit: 50

  def index
    respond_to do |format|
      format.any(:html, :mobile) {
        all_my_jobs = ServiceCall.jobs_to_work_on(current_user.organization).all(order: 'id DESC')
        all_transferred_job = ServiceCall.my_transferred_jobs(current_user.organization).all(order: 'id DESC')
        # a set of data for each tab
        @new_jobs    = all_my_jobs.select {|j| [:pending, :canceled].include? j.work_status_name}
        @new_transferred_jobs = all_transferred_job.select {|j| [:pending, :canceled, :rejected].include? j.work_status_name}

        @active_jobs    = all_my_jobs.select {|j| [:in_progress, :accepted, :dispatched].include? j.work_status_name}
        @active_transferred_jobs = all_transferred_job.select {|j| j.work_status_name == :in_progress}

        @done_jobs    = all_my_jobs.select {|j| j.work_status_name == :done}
        @done_transferred_jobs = all_transferred_job.select {|j| j.work_status_name == :done}
      }

      format.json { render json: TicketsDatatable.new(view_context) }
    end

  end

  def show
    store_location
    respond_to do |format|
      format.html do
        @customer = Customer.new
        @bom      = Bom.new
      end
    end

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
    @bom = Bom.new
    respond_to do |format|
      if @service_call.update_attributes(permitted_params(@service_call).service_call)

        format.js {}

        format.html do
          flash[:success] = t('service_call.crud_messages.update.success')
          redirect_to service_call_path @service_call
        end

        format.mobile do
          flash[:success] = t('service_call.crud_messages.update.success')
          redirect_to service_call_path @service_call
        end

        format.json do
          update_params_for_bip
          respond_with_bip @service_call
        end

      else
        format.js { respond_bip_error @service_call }
        format.html do
          flash[:error] = t('service_call.crud_messages.update.error', msg: @service_call.errors.full_messages)
          render :action => 'show'
        end

        format.mobile do
          flash[:error] = t('service_call.crud_messages.update.error', msg: @service_call.errors.full_messages)
          redirect_to service_call_path @service_call
        end

        format.json { respond_bip_error @service_call.becomes(ServiceCall) }
      end
    end
  end


  def new_service_call_from_params
    @service_call ||= ServiceCall.new_from_params(current_user.organization, permitted_params(nil).service_call)
    # this is to work around a textile best_in_place issue which causes html tags to dislay when editing for the first time
    @service_call.notes = "**" if @service_call.notes.nil? || @service_call.notes.empty?
  end

  def load_service_call
    @service_call = Ticket.find(params[:id])
  end

  # TODO move autocomplete to CustomerController
  def autocomplete_customer_name_where
    Rails.logger.debug { "Invoked #{self.class.name}#autocomplete_customer_name_where" }
    default = "organization_id = #{current_user.organization.id} AND status = #{Customer::STATUS_ACTIVE}"

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

  def update_params_for_bip
    params[:my_service_call] = params[:service_call]
    params[:subcon_service_call] = params[:service_call]
    params[:broker_service_call]  = params[:service_call]
  end

end

