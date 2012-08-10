class ProvidersController < ApplicationController
  before_filter :authenticate_user!

  def new

    if params[:search].nil?
      @provider = current_user.organization.providers.build
    else

    end

  end

  def create
    #begin
    #  #@provider = current_user.organization.create_provider!(params)
    #
    #
    #rescue ActiveRecord::RecordInvalid
    #  logger.debug "ActiveRecord::RecordInvalid"
    #  render 'new'
    #end
    params[:provider][:organization_role_ids] = [OrganizationRole::PROVIDER_ROLE_ID]
    params[:provider][:status_event] = :make_local
    @provider = current_user.organization.providers.new(params[:provider])
    @provider.agreements.new(subcontractor_id: current_user.organization.id, provider_id: @provider)
    if @provider.save
      redirect_to @provider, :notice => t('providers.flash.create_provider', name: @provider.name)
    else
      render 'new'

    end

  end

  def edit
    @provider = current_user.organization.providers.find(params[:id])
  end

  def update
    @provider = current_user.organization.providers.find(params[:id])
    if @provider.update_attributes(params[:provider])
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

      @providers = Provider.provider_search(current_user.organization.id, "").paginate(page: params[:page], per_page: 10)
    else
      @providers = Provider.provider_search(current_user.organization.id, params[:search]).paginate(page: params[:page], per_page: 10)
    end


  end

  def show
    @provider = current_user.organization.providers.find(params[:id])
  end
end
