class Api::V1::ApiController < ActionController::Base
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_filter :authenticate_user_from_token!

  include Userstamp

  around_filter :user_time_zone, if: :current_user
  before_filter { |c| Authorization.current_user = c.current_user }

  private

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def record_not_found
    render json: { error: "Record '#{params[:id]}' Not Found" }, status: :not_found
  end

end