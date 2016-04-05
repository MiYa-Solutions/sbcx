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
          if current_user.role_ids.include?(Role::ORG_ADMIN_ROLE_ID) || current_user.role_ids.include?(Role::DISPATCHER_ROLE_ID)
            render_admin_home_page
          else
            render_technician_home_page
          end
        end

        format.mobile do
          if current_user.role_ids.include?(Role::ORG_ADMIN_ROLE_ID) || current_user.role_ids.include?(Role::TECHNICIAN_ROLE_ID)
            render_mobile_admin_home_page
          else
            render_mobile_technician_home_page
          end
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

  private

  def render_admin_home_page
    @notifications = current_user.notifications
    @service_calls = current_user.organization.active_jobs
    @aff_accounts    = Account.for_affiliates_with_balance(current_user.organization)
    @customer_accounts    = Account.for_customers_with_balance(current_user.organization)

    render 'home'
  end

  def render_technician_home_page
    @notifications = current_user.notifications
    @service_calls = current_user.organization.active_jobs

    render 'technician_home'

  end

  def render_mobile_admin_home_page
    @notifications = current_user.notifications.order('id desc').limit(5)
    @appointments  = current_user.organization.appointments.where('starts_at >= ?', Time.zone.today).order('starts_at ASC').limit(10)
    render 'home'
  end

  def render_mobile_technician_home_page
    @notifications = current_user.notifications.order('id desc').limit(5)
    @appointments  = current_user.organization.appointments.where('starts_at >= ?', Time.zone.today).order('starts_at ASC').limit(10)
    render 'technician_home'

  end
end
