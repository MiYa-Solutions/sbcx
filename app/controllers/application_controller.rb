class ApplicationController < ActionController::Base
  protect_from_forgery

  include Userstamp

  before_filter { |c| Authorization.current_user = c.current_user }

  protected

  def permission_denied
    flash[:error] = t('authorization.permission_denied')
    redirect_to root_url
  end

  def permitted_params(obj)
    @permitted_params ||= PermittedParams.new(params, current_user, obj)
  end

  helper_method :permitted_params
end

