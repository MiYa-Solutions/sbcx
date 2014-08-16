class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!
  #filter_access_to :welcome, :require => :read

  def welcome
    if user_signed_in?
      respond_to do |format|
        format.html
        format.mobile
      end
    else
      redirect_to new_user_session_path, notice: t('devise.failure.unauthenticated')
    end
  end

  def home
    if user_signed_in?
      respond_to do |format|
        format.html do
          @notifications = current_user.notifications
          @service_calls = current_user.organization.active_jobs
          @aff_accounts    = Account.for_affiliates_with_balance(current_user.organization)
          @customer_accounts    = Account.for_customers_with_balance(current_user.organization)
        end

        format.mobile do
          @notifications = current_user.notifications.order('id desc').limit(5)
          @appointments  = current_user.organization.appointments.where('starts_at >= ?', Time.zone.today).order('starts_at ASC').limit(10)
        end

      end

    else
      redirect_to new_user_session_path, notice: t('devise.failure.unauthenticated')
    end
  end

  def calendar
    @tickets         = Ticket.by_date(params[:date], @org.id)
    @tickets_by_date = Ticket.where("organization_id = ? ", @org.id)

  end

  def index
    @message = Message.new
  end
end
