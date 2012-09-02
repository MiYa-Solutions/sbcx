class RegistrationsController < Devise::RegistrationsController
  def edit
    #new Ishay
    @organization = current_user.organization
    super

  end

  def show
    @organization = current_user.organization
    @current_user = current_user
    #new Ishay
    @users        = @organization.users
  end

  def new
    resource      = build_resource({ })
    @user         = User.new
    @organization = @user.build_organization

  end

  # todo make registration work with an organization and a user created at the same time
  def create

    @user = build_resource
    @user.organization.make_sbcx_member
    @user.role_ids = [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME).id]


    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
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


  #def update
  #  super
  #  #@user = User.find_by_email(params[:user][:email])
  #  #
  #  #self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  #  #
  #  #if resource.update_with_password(params[resource_name])
  #  #  if is_navigational_format?
  #  #    if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
  #  #      flash_key = :update_needs_confirmation
  #  #    end
  #  #    set_flash_message :success, flash_key || :updated
  #  #  end
  #  #  sign_in resource_name, resource, :bypass => true
  #  #  respond_with resource, :location => after_update_path_for(resource)
  #  #else
  #  #  clean_up_passwords resource
  #  #  respond_with resource
  #  #end
  #end

  def after_update_path_for(resource)
    profile_path
  end

end
