class ProvidersController < ApplicationController
  def new
    @provider = current_user.organization.providers.build
  end

  def create
    params[:organization][:organization_role_ids] =  [OrganizationRole::PROVIDER_ROLE_ID]

    # todo the below is not safe as the provider save can fail and as a result the agreement will not be saved
    @provider = current_user.organization.providers.build(params[:organization])
    @provider.save

    if current_user.organization.add_provider!(@provider)
      redirect_to provider_path(@provider), :notice => "Successfully created provider."
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
