class AgreementsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  def new
    #@agreement = Agreement.new
    #@providers = Organization.find_all_by_subcontrax_member(true)
  end

  def create

    if @agreement.save
      redirect_to agreement_path @agreement
    else
      render :new
    end


  end

  def edit
    #@agreement = Agreement.find(params[:id])
  end

  def update
    #@agreements = Agreements.find(params[:id])
    if @agreement.update_attributes(permitted_params(@agreement).agreement)
      redirect_to @agreement.becomes(Agreement), :notice => "Successfully updated agreements."
    else
      render :action => 'edit'
    end
  end

  def show

  end

  def new_agreement_from_params

    if params[:agreement].nil?
      otherparty_id   = params[:otherparty_id]
      otherparty_role = params[:otherparty_role]
      type            = params[:agreement_type]

      @agreement = Agreement.new_agreement(type, current_user.organization, otherparty_id, otherparty_role)
    else
      @agreement = Agreement.new_agreement_from_params(params[:agreement_type], permitted_params(nil).agreement)
    end

    @agreement
  end

end
