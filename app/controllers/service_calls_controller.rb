class ServiceCallsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access


  def index
    @service_calls = current_user.organization.service_calls
  end

  def show
    @service_call = ServiceCall.find(params[:id])
    @customer     = Customer.new
  end

  def new
    @service_call = ServiceCall.new
    @customer     = Customer.new
  end

  def create

    @service_call = current_user.organization.service_calls.new(params[:service_call])
    set_service_call_type
    # copy instance variables as it is lost in the 'becomes' method call
    service_call_instance              = @service_call.becomes(@service_call.type.constantize)
    service_call_instance.new_customer = @service_call.new_customer

    # save the service call through it's type to invoke the proper call backs
    if service_call_instance.save
      redirect_to service_call_path @service_call, :notice => t('service_call.crud_messages.success')
    else
      render :action => 'new'
    end
  end

  def edit
    @service_call = ServiceCall.find(params[:id])
  end

  def update
    @service_call = ServiceCall.find(params[:id])
    if @service_call.update_attributes(params[:service_call])
      redirect_to service_call_path @service_call, :notice => "Successfully updated service call."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @service_call = ServiceCall.find(params[:id])
    @service_call.destroy
    redirect_to service_calls_url, :notice => "Successfully destroyed service call."
  end

  private

  def set_service_call_type

    case @service_call.my_role
      when :prov
        #@service_call      = @service_call.becomes(MyServiceCall)
        @service_call.type = "MyServiceCall"
        @service_call.becomes(MyServiceCall).init_state_machines


      when :subcon
        #@service_call      = @service_call.becomes(TransferredServiceCall)
        @service_call.type = "TransferredServiceCall"
        @service_call.becomes(TransferredServiceCall).init_state_machines

      else
        #@service_call      = @service_call.becomes(MyServiceCall)
        #@service_call.type = "MyServiceCall"
        raise "Unexpected service call my_role"
    end

    #@service_call.organization = current_user.organization
    #@service_call.init_state_machines
    #@service_call.init_state_machines
    #@service_call.save

  end

  def process_event

    case params[:status_event]
      when 'transfer'
        #@service_call.subcontractor = Subcontractor.find(params[:service_call][:subcontractor]) unless params[:service_call][:subcontractor].nil?
        @service_call.subcontractor_id = params[:service_call][:subcontractor] unless params[:service_call][:subcontractor].empty?

      when 'dispatch'
        @service_call.technician = User.find(params[:service_call][:technician]) unless params[:service_call][:technician].empty?
      when 'paid'
        @service_call.total_price = params[:service_call][:total_price] unless params[:service_call][:total_price].empty?
      else
        @service_call.send(params[:status_event].to_sym) #, recipient: subcontractor)

    end

    @service_call.send(params[:status_event].to_sym) #, recipient: subcontractor)


  end

end
