class PasswordsController < Devise::PasswordsController

  def build_resource(hash=nil)
    hash          ||= params[resource_name].permit(*permitted_params(nil).new_user_attributes) || {}
    self.resource = resource_class.new_with_session(hash, session)
  end

  private

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end

end