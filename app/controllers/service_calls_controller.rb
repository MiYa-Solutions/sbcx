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

    if @service_call.save
      redirect_to @service_call.becomes(ServiceCall), :notice => "Successfully created service call."
    else
      @service_call.becomes(ServiceCall)
      render :action => 'new'
    end
  end

  def edit
    @service_call = ServiceCall.find(params[:id])
  end

  def update
    @service_call = ServiceCall.find(params[:id])
    if params[:status_event].nil?
      if @service_call.update_attributes(params[:service_call])
        redirect_to @service_call, :notice => "Successfully updated service call."
      else
        render :action => 'edit'
      end
    else

      process_event
      #@service_call.transfer(recipient: subcontractor)
      render 'show'
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
        @service_call      = @service_call.becomes(MyServiceCall)
        @service_call.type = "MyServiceCall"

      when :subcon
        @service_call      = @service_call.becomes(TransferredServiceCall)
        @service_call.type = "TransferredServiceCall"

      else
        @service_call      = @service_call.becomes(MyServiceCall)
        @service_call.type = "MyServiceCall"
    end
    #@service_call.organization = current_user.organization
    @service_call.init_state_machines

  end

  def process_event

    case params[:status_event]
      when 'transfer'
        #@service_call.subcontractor = Subcontractor.find(params[:service_call][:subcontractor]) unless params[:service_call][:subcontractor].nil?
        @service_call.subcontractor_id = params[:service_call][:subcontractor] unless params[:service_call][:subcontractor].nil?

      when 'dispatch'
        @service_call.technician = User.find(params[:service_call][:technician]) unless params[:service_call][:technician].nil?
      else
        @service_call.send(params[:status_event].to_sym) #, recipient: subcontractor)

    end

    @service_call.send(params[:status_event].to_sym) #, recipient: subcontractor)


  end

end
