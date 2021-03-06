class SubcontractorsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  def new

    #@subcontractor = current_user.organization.subcontractors.build
  end

  def create

    #@subcontractor = current_user.organization.subcontractors.new(permitted_params(nil).subcontractor)
    #@subcontractor.agreements.new(subcontractor_id: @subcontractor, provider_id: current_user.organization.id)
    if current_user.organization.save
      redirect_to @subcontractor, :notice => t('subcontractors.flash.create', name: @subcontractor.name)
    else
      render 'new'

    end

  end

  def edit
    #@subcontractor = current_user.organization.subcontractors.find(params[:id])
  end

  def update
    #@subcontractor = current_user.organization.subcontractors.find(params[:id])
    if @subcontractor.update_attributes(permitted_params(@subcontractor).subcontractor)
      redirect_to subcontractor_path(@subcontractor), :notice => "Successfully updated subcontractor."
    else
      render :action => 'edit'
    end
  end

  #def destroy
  #  @subcontractor = Subcontractor.find(params[:id])
  #  @subcontractor.destroy
  #  redirect_to subcontractors_url, :notice => "Successfully destroyed subcontractor."
  #end

  def index
    if params[:search].nil?

      @subcontractors = current_user.organization.subcontractors.paginate(page: params[:page], per_page: 30)
    else
      @subcontractors = Subcontractor.subcontractor_search(current_user.organization.id, params[:search]).paginate(page: params[:page], per_page: 30)
    end

    #@subcontractors = current_user.organization.subcontractors.paginate(page: params[:page], per_page: 5)
    #@subcontractors = current_user.organization.subcontractor_candidates(params[:search])
  end


  def show
    #@subcontractor = current_user.organization.subcontractors.find(params[:id])
    @agreements = current_user.organization.agreements.where(counterparty_id: @subcontractor.id)
  end

  def new_subcontractor_from_params
    #add the appropriate role
    params[:subcontractor][:organization_role_ids] = [OrganizationRole::SUBCONTRACTOR_ROLE_ID] unless params[:subcontractor].nil?

    @subcontractor ||= current_user.organization.subcontractors.new(permitted_params(nil).subcontractor)
  end

end
