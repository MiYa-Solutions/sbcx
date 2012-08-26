class ServiceCallsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @service_calls = current_user.organization.service_calls
  end

  def show
    @service_call = ServiceCall.find(params[:id])
    @customer = Customer.new
  end

  def new
    @service_call = ServiceCall.new
    @customer = Customer.new
  end

  def create

    @service_call = current_user.organization.service_calls.new(params[:service_call])
    #@service_call.organization = current_user.organization
    if @service_call.save
      redirect_to @service_call, :notice => "Successfully created service call."
    else
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
      subcontractor = Subcontractor.find(params[:service_call][:subcontractor])
      @service_call.transfer(recipient: subcontractor)
      render 'show'
    end

  end

  def destroy
    @service_call = ServiceCall.find(params[:id])
    @service_call.destroy
    redirect_to service_calls_url, :notice => "Successfully destroyed service call."
  end
end
