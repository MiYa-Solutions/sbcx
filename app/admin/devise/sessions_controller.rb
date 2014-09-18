class ActiveAdmin::Devise::SessionsController
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
    hash             ||= validated_params.permit(*permitted_params) || { }
    self.resource    = AdminUser.new(hash)
  end

  private

  def resource_params
    params.require(:admin_user).permit(:email, :password) if resource.kind_of? (AdminUser)
  end
end
