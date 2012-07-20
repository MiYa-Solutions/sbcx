class SubcontractorsController < ApplicationController
  before_filter :authenticate_user!

  def new

    @subcontractor = current_user.organization.subcontractors.build
  end

  def create
    #begin
    #  #params[:subcontractor][:organization_role_ids] = [OrganizationRole::SUBCONTRACTOR_ROLE_ID]
    #  @subcontractor = current_user.organization.create_subcontractor!(params[:subcontractor])
    #  redirect_to @subcontractor
    #
    #rescue ActiveRecord::RecordInvalid
    #  render @subcontractor
    #
    #end
    params[:subcontractor][:organization_role_ids] = [OrganizationRole::SUBCONTRACTOR_ROLE_ID]
    @subcontractor                                 = current_user.organization.subcontractors.build(params[:subcontractor])

    agreement = @subcontractor.agreements.build(provider_id: current_user.organization.id, subcontractor_id: @subcontractor)
    if agreement.save
      redirect_to @subcontractor, :notice => "Successfully created Subcontractor."
    else
      render 'new'

    end


    #begin
    #  @subcontractor = current_user.organization.create_subcontractor!(params)
    #  redirect_to @subcontractor, :notice => "Successfully created subcontractor."
    #
    #rescue ActiveRecord::RecordInvalid
    #  logger.debug "ActiveRecord::RecordInvalid"
    #  @subcontractor = current_user.organization.subcontractors.build
    #  @subcontractor.
    #  render :new
    #end
  end

  def edit
    @subcontractor = current_user.organization.subcontractors.find(params[:id])
  end

  def update
    @subcontractor = current_user.organization.subcontractors.find(params[:id])
    if @subcontractor.update_attributes(params[:subcontractor])
      redirect_to subcontractor_path(@subcontractor), :notice => "Successfully updated subcontractor."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @subcontractor = Subcontractor.find(params[:id])
    @subcontractor.destroy
    redirect_to subcontractors_url, :notice => "Successfully destroyed subcontractor."
  end

  def index
    @new_subcontractors = current_user.organization.subcontractors.all
    @subcontractors     = current_user.organization.subcontractor_candidates(params[:search])
  end

  def show
    @subcontractor = current_user.organization.subcontractors.find(params[:id])
  end
end
