class AgreementsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @agreement = Agreement.new

    @providers = Organization.find_all_by_subcontrax_member(true)
  end

  def create
    if params[:agreement][:provider_id].nil?
      @agreements = Agreements.new(params[:agreements])
      if @agreements.save
        redirect_to root_url, :notice => "Successfully created agreements."
      else
        render :action => 'new'
      end
    else
      provider = Provider.find(params[:agreement][:provider_id])
      current_user.organization.add_provider(provider)
      redirect_to providers_path
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
end
