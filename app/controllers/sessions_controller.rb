class SessionsController < Devise::SessionsController

  # overriding devise create in order to properly redirect mobile devises after sign in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if mobile_device?
      redirect_to user_root_path
    else
      respond_with resource, :location => redirect_location(resource_name, resource)
    end
  end
end