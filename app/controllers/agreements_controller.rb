class AgreementsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  def new
    #@agreement = Agreement.new
    #@providers = Organization.find_all_by_subcontrax_member(true)
  end

  def create

    if @agreement.save
      redirect_to agreement_path @agreement.becomes(Agreement)
    else
      raise "Can't save Agreement"
    end


  end

  def edit
    @agreements = Agreements.find(params[:id])
  end

  def update
    @agreements = Agreements.find(params[:id])
    if @agreements.update_attributes(params[:agreements])
      redirect_to root_url, :notice => "Successfully updated agreements."
    else
      render :action => 'edit'
    end
  end

  def show

  end

  def new_agreement_from_params
    if params[:agreement].nil? || params[:agreement][:organization_id].nil? || params[:agreement][:organization_id] == current_user.organization.id
      org = current_user.organization
    else
      org = Organization.find(params[:agreement][:organization_id])
    end
    @agreement ||= org.send(params[:agreement][:agreement_type].pluralize).build(permitted_params(nil).send(params[:agreement][:agreement_type])) unless org.nil?

  end
end
