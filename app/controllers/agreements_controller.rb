class AgreementsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  def new
    @agreement = Agreement.new

    @providers = Organization.find_all_by_subcontrax_member(true)
  end

  def create

    if !params[:agreement][:provider_id].nil? && !params[:agreement][:subcontractor_id].nil? # are we adding a member?
      org = Organization.find(params[:agreement][:provider_id])
      current_user.organization.reverse_agreements.new(provider_id: params[:agreement][:provider_id])
      current_user.organization.agreements.new(subcontractor_id: org.id)

    else
      if params[:agreement][:subcontractor_id] # are we adding a provider?
        org = Subcontractor.find(params[:agreement][:subcontractor_id])
        current_user.organization.add_subcontractor(org)


      else #
        org = Provider.find(params[:agreement][:provider_id])
        current_user.organization.add_provider(org)

      end
    end

    if current_user.organization.save
      redirect_to affiliate_path(org.id)
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

  def new_agreement_from_params
    @agreement ||= Agreement.new(params.permit)
  end
end
