class ApplicationController < ActionController::Base
  protect_from_forgery

  include Userstamp

  around_filter :user_time_zone, if: :current_user

  before_filter { |c| Authorization.current_user = c.current_user || session[:user] }
  # todo make counting more efficient
  before_filter { |c| @notification_count = Notification.where(user_id: c.current_user.id).where(status: Notification::NOTIFICATION_UNREAD).count unless current_user.nil? }
  before_filter { |c| @org = c.current_user.organization unless c.current_user.nil? }

  before_filter :prepare_for_mobile

  def permitted_params(obj = nil)
    if params[:controller].include?('admin/')
      @permitted_params ||= PermittedParams.new(params, current_user, obj).admin_user
    else
      @permitted_params ||= PermittedParams.new(params, current_user, obj)
    end
  end

  helper_method :permitted_params

  protected

  def permission_denied
    #flash[:error] = t('authorization.permission_denied')
    redirect_to "/403"
  end

  private
  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or_to(alternate)
    redirect_to(session[:return_to] || alternate)
    clear_stored_location
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

end

