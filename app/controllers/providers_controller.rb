class ProvidersController < ApplicationController
  before_filter :authenticate_user!

  filter_resource_access

  def new
    # no need for the below as declarative_authorization filter_resource_access taks care of it
    #@provider = current_user.organization.providers.new

  end

  def create
    #@provider.subcontractors << current_user.organization.becomes(Subcontractor)
    if current_user.organization.save #@provider.save
      redirect_to @provider, :notice => t('providers.flash.create_provider', name: @provider.name)
    else
      render 'new'

    end

  end

  def edit
    #@provider = current_user.organization.providers.find(params[:id])
  end

  def update
    #@provider = current_user.organization.providers.find(params[:id])
    if @provider.update_attributes(permitted_params(@provider).provider)
      redirect_to @provider, :notice => "Successfully updated provider."
    else
      render :action => 'edit'
    end
  end

  # provider can't be destroyed. instead it just needs to move to an disabled status
  #def destroy
  #  @provider = Provider.find(params[:id])
  #  @provider.destroy
  #  redirect_to providers_url, :notice => "Successfully destroyed provider."
  #end

  def index
    if params[:search].nil?

      @providers = current_user.organization.providers.paginate(page: params[:page], per_page: 10)

    else
      @providers = Provider.provider_search(current_user.organization.id, params[:search]).paginate(page: params[:page], per_page: 10)

    end


  end


  def show
    #@provider = Provider.find(params[:id])
    @agreement = Agreement.new
    @agreements = @provider.agreements
  end

  def new_provider_from_params
    unless params[:provider].nil?
      params[:provider][:organization_role_ids] = [OrganizationRole::PROVIDER_ROLE_ID]
      params[:provider][:status_event]          = :make_local
    end

    @provider ||= current_user.organization.providers.new(permitted_params(nil).provider)
  end

end
