class ServiceCallsController < ApplicationController
  before_filter :authenticate_user!
  filter_access_to :autocomplete_customer_name, :require => :index
  filter_resource_access

  autocomplete :customer, :name, extra_data: [:address1, :address2, :company, :phone, :email, :mobile_phone, :work_phone, :country, :state, :city, :zip], full: true, limit: 50

  def index
    respond_to do |format|
      format.html {}
      format.mobile {
        all_my_jobs           = ServiceCall.jobs_to_work_on(current_user.organization).includes(:provider, :organization, :customer).all(order: 'id DESC')
        all_transferred_job   = ServiceCall.my_transferred_jobs(current_user.organization).includes(:provider, :subcontractor, :organization, :customer).all(order: 'id DESC')
        # a set of data for each tab
        @new_jobs             = all_my_jobs.select { |j| [:pending, :canceled, :rejected].include? j.work_status_name }
        @new_transferred_jobs = all_transferred_job.select { |j| [:accepted, :pending, :canceled, :rejected].include? j.work_status_name }

        @active_jobs             = all_my_jobs.select { |j| [:in_progress, :accepted, :dispatched].include? j.work_status_name }
        @active_transferred_jobs = all_transferred_job.select { |j| [:in_progress, :dispatched].include? j.work_status_name }

        @done_jobs             = all_my_jobs.select { |j| j.work_status_name == :done }
        @done_transferred_jobs = all_transferred_job.select { |j| j.work_status_name == :done }
      }

      format.json {
        if params[:counter].present?
          render json: TicketCounter.new(view_context)
        else
          render json: TicketsDatatable.new(view_context)
        end
      }
      format.csv { render_csv }
      format.xls { send_data JobsCsvExport.new(view_context).get_csv(col_sep: "\t"), as: 'application/xls' }
    end

  end

  def show
    store_location
    respond_to do |format|
      format.any(:html, :mobile) do
        @customer = Customer.new
        @bom      = Bom.new
      end
      format.pdf do
        partial = params[:template].present? ? params[:template] : 'show'
        render pdf:                    "job_#{@service_call.id}",
               layout:                 'service_calls',
               template:               "service_calls/#{partial}.pdf",
               footer:                 { html: { template: 'layouts/_footer.pdf.erb' } },
               header:                 { html: { template: 'layouts/_header.pdf.erb' } },
               disable_internal_links: false


      end

    end

  end

  def new
    # @service_call = ServiceCall.new
    @customer = Customer.new
    store_location
  end

  def create

    respond_to do |format|
      sanitize_mobile_tag_list if request.format == 'mobile'
      if @service_call.save
        flash[:success] = t('service_call.crud_messages.success')
        format.any(:html, :mobile) { redirect_to service_call_path @service_call }
      else
        format.any(:html, :mobile) { render 'new' }
      end

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
          render json: @service_call, status: :ok
        end

      else
        format.js { respond_bip_error @service_call }
        format.html do
          flash[:error] = t('service_call.crud_messages.update.error', msg: @service_call.errors.full_messages)
          redirect_to service_call_path @service_call
        end

        format.mobile do
          flash[:error] = t('service_call.crud_messages.update.error', msg: @service_call.errors.full_messages)
          redirect_to service_call_path @service_call
        end

        format.json { respond_bip_error @service_call.becomes(ServiceCall) }
      end
    end
  end

  def destroy

    if TicketDeletionService.new(@service_call).execute
      flash[:success] = t('service_call.crud_messages.destroy.success')
      redirect_to service_calls_path
    else
      flash[:error] = t('service_call.crud_messages.destroy.error',msg: @service_call.errors.full_messages )
      redirect_to @service_call
    end

  end


  def new_service_call_from_params
    @service_call       ||= ServiceCall.new_from_params(current_user.organization, permitted_params(nil).service_call)
    # this is to work around a textile best_in_place issue which causes html tags to dislay when editing for the first time
    @service_call.notes = "**" if @service_call.notes.nil? || @service_call.notes.empty?
  end

  def load_service_call
    #@service_call = Ticket.find(params[:id])
    @service_call = Ticket.includes(boms: [:material], events: [:creator]).find(params[:id])
  end

  # TODO move autocomplete to CustomerController
  def autocomplete_customer_name_where
    Rails.logger.debug { "Invoked #{self.class.name}#autocomplete_customer_name_where" }
    default = "organization_id = #{current_user.organization.id} AND status = #{Customer::STATUS_ACTIVE}"

    if params[:ref_id].nil? || params[:ref_id].blank? || params[:ref_id] == '-1'
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
    params[:my_service_call]     = params[:service_call]
    params[:subcon_service_call] = params[:service_call]
    params[:broker_service_call] = params[:service_call]
  end

  protected

  def default_serializer_options
    {root: false}
  end



  private

  def render_csv
    set_file_headers
    set_streaming_headers

    response.status    = 200

    #setting the body to an enumerator, rails will iterate this enumerator
    self.response_body = csv_lines
  end


  def set_file_headers
    file_name                      = "jobs.csv"
    headers["Content-Type"]        = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end


  def set_streaming_headers
    #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines
    JobsCsvExport.new(view_context).get_csv_enumerator
  end

  def sanitize_mobile_tag_list
    unless params[:service_call].nil? || params[:service_call][:tag_list].nil?
      @service_call.tag_list = params[:service_call][:tag_list].reject! { |t| t.empty? }.join(",")
    end
  end


end

