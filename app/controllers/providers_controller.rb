class ProvidersController < ApplicationController
  def new
    @provider = current_user.organization.providers.build
  end

  def create
    @provider = current_user.organization.providers.build(params[:provider])
    if @provider.save
      redirect_to @provider, :notice => "Successfully created provider."
    else
      render :action => 'new'
    end
  end

  def edit
    @provider = current_user.organization.providers.find(params[:id])
  end

  def update
    @provider = current_user.organization.providers.find(params[:id])
    if @provider.update_attributes(params[:provider])
      redirect_to @provider, :notice  => "Successfully updated provider."
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
    @providers = current_user.organization.providers.all
  end

  def show
    @provider = current_user.organization.providers.find(params[:id])
  end
end
