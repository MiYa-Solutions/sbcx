class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!
  #filter_access_to :welcome, :require => :read

  def welcome
    if user_signed_in?
      @notifications = current_user.notifications
      @service_calls = current_user.organization.service_calls
      @affiliates = current_user.organization.affiliates
    else
      redirect_to new_user_session_path, notice: t('devise.failure.unauthenticated')
    end
  end

  def calendar
    @tickets         = Ticket.by_date(params[:date], @org.id)
    @tickets_by_date = Ticket.where("organization_id = ? ", @org.id)

  end

  def index
  end
end
