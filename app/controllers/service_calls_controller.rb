class ServiceCallsController < ApplicationController
  before_filter :authenticate_user!
  filter_access_to :autocomplete_customer_name, :require => :index
  filter_resource_access

  autocomplete :customer, :name, full: true, limit: 50

  def index
    @service_calls = current_user.organization.service_calls
  end

  def show
    #@service_call = ServiceCall.find(params[:id])
    @customer = Customer.new
    @bom      = Bom.new
  end

  def new
    @service_call = ServiceCall.new
    @customer     = Customer.new
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
      end
    else
      respond_to do |format|
        format.js {}
        format.html do
          render :action => 'edit'
        end
      end


    end
  end


  def new_service_call_from_params
    @service_call ||= ServiceCall.new_from_params(current_user.organization, permitted_params(nil).service_call)
  end

  #def set_service_call_type
  #
  #  case @service_call.my_role
  #    when :prov
  #      #@service_call      = @service_call.becomes(MyServiceCall)
  #      @service_call.type = "MyServiceCall"
  #      @service_call.becomes(MyServiceCall).init_state_machines
  #
  #
  #    when :subcon
  #      #@service_call      = @service_call.becomes(TransferredServiceCall)
  #      @service_call.type = "TransferredServiceCall"
  #      @service_call.becomes(TransferredServiceCall).init_state_machines
  #
  #    else
  #      #@service_call      = @service_call.becomes(MyServiceCall)
  #      #@service_call.type = "MyServiceCall"
  #      raise "Unexpected service call my_role"
  #  end
  #
  #  #@service_call.organization = current_user.organization
  #  #@service_call.init_state_machines
  #  #@service_call.init_state_machines
  #  #@service_call.save
  #
  #end

  #def process_event
  #
  #  case params[:status_event]
  #    when 'transfer'
  #      #@service_call.subcontractor = Subcontractor.find(params[:service_call][:subcontractor]) unless params[:service_call][:subcontractor].nil?
  #      @service_call.subcontractor_id = params[:service_call][:subcontractor] unless params[:service_call][:subcontractor].empty?
  #
  #    when 'dispatch'
  #      @service_call.technician = User.find(params[:service_call][:technician]) unless params[:service_call][:technician].empty?
  #    else
  #      @service_call.send(params[:status_event].to_sym) #, recipient: subcontractor)
  #
  #  end
  #
  #  @service_call.send(params[:status_event].to_sym) #, recipient: subcontractor)
  #
  #
  #end

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

