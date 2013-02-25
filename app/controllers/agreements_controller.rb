class AgreementsController < ApplicationController
  before_filter :authenticate_user!
  filter_resource_access

  def new
    #@agreement = Agreement.new
    #@providers = Organization.find_all_by_subcontrax_member(true)
  end

  def create

    type_err = @agreement.errors[:type]

    if @agreement.save
      respond_to do |format|
        format.html { redirect_to agreement_path @agreement }
        format.mobile { redirect_to agreement_path @agreement }
        format.js {}

      end

    else
      @agreement.errors[:type].concat type_err if type_err.present?
      respond_to do |format|
        format.html { render :new }
        format.mobile { render :new }
        format.js {}
      end

    end


  end

  def edit
    #@agreement = Agreement.find(params[:id])
  end

  def update
    respond_to do |format|

      if @agreement.update_attributes(permitted_params(@agreement).agreement)
        format.html { redirect_to @agreement.becomes(Agreement), :notice => "Successfully updated agreements." }
        format.json { head :no_content }
      else
        format.html {render :action => 'edit'}
        format.json { render json: @agreement.errors, status: :unprocessable_entity }
      end
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
