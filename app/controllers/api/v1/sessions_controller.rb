class Api::V1::SessionsController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, only: [:destroy], fallback_to_devise: false


  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    current_user.update_attributes authentication_token: nil

    respond_to do |format|
      format.json {
        render :json => {
                   :user                 => current_user.email,
                   :status               => :ok,
                   :authentication_token => current_user.authentication_token
               }
      }
    end
  end

  def destroy
    respond_to do |format|
      format.json {
        if current_user
          current_user.update_attributes authentication_token: nil
          signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
          render :json => {}.to_json, :status => :ok
        else
          render :json => {}.to_json, :status => :unprocessable_entity
        end
      }
    end
  end

  protected

  def resource_name
    :user
  end

  def verify_signed_out_user
    authenticate_user_from_token!
  end

end