class OrgSettingsController < ApplicationController
  before_filter :authenticate_user!
  filter_access_to :all,  model: 'OrgSettings'

  # GET /org_settings
  # GET /org_settings.json
  def show
    @org_settings = current_user.organization.settings

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @settings }
    end
  end

  def edit
    @org_settings = current_user.organization.settings
  end

  # PATCH/PUT /org_settings
  # PATCH/PUT /org_settings.json
  def update
    @org_settings = current_user.organization.settings

    respond_to do |format|
      if @org_settings.save(settings_params)
        format.html { redirect_to org_settings_path(@org_settings), notice: 'Setting was successfully updated.' }
        format.json { head :no_content, status: :ok }
      else
        format.html { render action: "edit" }
        format.json { render :json => @org_settings.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def settings_params
    params.require(:org_settings).permit(*OrgSettings.fields)
  end
end
