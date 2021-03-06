class SettingsController < ApplicationController
  before_filter :authenticate_user!
  filter_access_to :all,  model: 'Settings'

  # GET /settings/1
  # GET /settings/1.json
  def show
    @settings = current_user.settings

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @settings }
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    @settings = current_user.settings

    respond_to do |format|
      if @settings.save(settings_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render :json => @setting.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def settings_params
    params.require(:settings).permit!
  end
end
