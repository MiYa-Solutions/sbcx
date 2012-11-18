class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!
  #filter_access_to :welcome, :require => :read

  def welcome
    unless user_signed_in?
      flash[:error] = "Please login first"
      render 'index'
    end
    @notifications = current_user.try(:notifications)
  end

  def index
  end
end
