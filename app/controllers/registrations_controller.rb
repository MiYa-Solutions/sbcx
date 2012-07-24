class RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource({})
    @user = User.new
    @organization = @user.build_organization

  end

  def create
    super
  end

  #def create
  #  # todo make registration work with an organization and a user created at the same time
  #  #build_resource
  #  @user = User.new(params[:user])
  #
  #
  #  if @user.save
  #    if @user.active_for_authentication?
  #      set_flash_message :notice, :signed_up if is_navigational_format?
  #      sign_in('User', @user)
  #      respond_with @user, :location => after_sign_up_path_for(@user)
  #    else
  #      set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
  #      expire_session_data_after_sign_in!
  #      respond_with resource, :location => after_inactive_sign_up_path_for(resource)
  #    end
  #  else
  #    clean_up_passwords resource
  #    respond_with resource
  #  end
  #end

  def update
    super
  end
end
