class SessionsController < Devise::SessionsController

  # overriding devise create in order to properly redirect mobile devises after sign in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if mobile_device?
      redirect_to user_root_path
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end

  def build_resource(hash=nil)
    validated_params ||= params[resource_name] || ActionController::Parameters.new
    hash             ||= validated_params.permit(*permitted_params(nil).new_user_attributes) || { }
    self.resource    = resource_class.new_with_session(hash, session)
  end

  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end