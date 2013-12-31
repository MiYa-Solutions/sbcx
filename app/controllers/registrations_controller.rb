class RegistrationsController < Devise::RegistrationsController
  #before_filter :permit_params
  def edit
    @organization = current_user.organization
    super
  end

  def update
    @organization = current_user.organization
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_with_password(resource_params)
      if is_navigational_format?
        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
          flash_key = :update_needs_confirmation
        end
        set_flash_message :notice, flash_key || :updated
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end

  end

  def show
    @organization = current_user.organization
    @current_user = current_user
    #new Ishay
    @users        = @organization.users
  end

  def new
    if ENV['LOCK_SBCX_REG'].present? && params[:naul].nil?
      redirect_to contact_us_path, notice: "SubConTraX is in closed BETA mode. If you would like to join our beta user group please contact us using the form below."
    end
    resource      = build_resource({})
    @user         = User.new
    @organization = @user.build_organization

  end

  # todo make registration work with an organization and a user created at the same time
  def create

    @user = build_resource
    @user.organization.make_sbcx_member
    @organization  = @user.organization
    @user.role_ids = [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME).id]


    if resource.save
      if resource.active_for_authentication?
        set_flash_message :success, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end


  end

  def after_update_path_for(resource)
    profile_path
  end

  # From Devise: Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  # From MiYa: need to override for strong parameters
  def build_resource(hash=nil)
    #hash          ||= params[resource_name].permit(*permitted_params(nil).new_user_attributes) || { }
    hash          ||= permitted_params(nil).registration || {}
    self.resource = resource_class.new_with_session(hash, session)
  end

  private

  def resource_params
    permitted_params(nil).registration
    #params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def after_sign_up_path_for(resource)
    welcome_path
  end


end
