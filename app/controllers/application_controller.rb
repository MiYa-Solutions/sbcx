class ApplicationController < ActionController::Base
  protect_from_forgery

  include Userstamp

  before_filter { |c| Authorization.current_user = c.current_user }
  # todo make counting more efficient
  before_filter { |c| @notification_count = c.current_user.try(:notifications).try(:size) }

  def permitted_params(obj)
    @permitted_params ||= PermittedParams.new(params, current_user, obj)
  end

  helper_method :permitted_params

  protected

  def permission_denied
    flash[:error] = t('authorization.permission_denied')
    redirect_to root_url
  end


end

