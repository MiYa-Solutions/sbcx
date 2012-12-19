class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!
  #filter_access_to :welcome, :require => :read

  def welcome
    if user_signed_in?
      @notifications = current_user.notifications.where(:status => Notification::NOTIFICATION_UNREAD)
      @service_calls = current_user.organization.service_calls
    else
      flash[:error] = "Please login first"
      render 'index'
    end
  end

  def calendar
    @tickets         = Ticket.by_date(params[:date], @org.id)
    @tickets_by_date = Ticket.where("organization_id = ? ", @org.id)

  end

  def index
  end
end
