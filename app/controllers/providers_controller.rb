class ProvidersController < ApplicationController
  def new

    if params[:search].nil?
      @provider = current_user.organization.providers.build
    else

    end

  end

  def create
    begin
      @provider = current_user.organization.create_provider!(params)
      redirect_to @provider, :notice => "Successfully created provider."

    rescue ActiveRecord::RecordInvalid
      logger.debug "ActiveRecord::RecordInvalid"
      render :new
    end
  end

  def edit
    @provider = current_user.organization.providers.find(params[:id])
  end

  def update
    @provider = current_user.organization.providers.find(params[:id])
    if @provider.update_attributes(params[:organization])
      redirect_to provider_path(@provider), :notice => "Successfully updated provider."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @provider = Provider.find(params[:id])
    @provider.destroy
    redirect_to providers_url, :notice => "Successfully destroyed provider."
  end

  def index
    @new_providers = current_user.organization.providers.all
    @providers     = current_user.organization.provider_candidates(params[:search])
  end

  def show
    @provider = current_user.organization.providers.find(params[:id])
  end
end
