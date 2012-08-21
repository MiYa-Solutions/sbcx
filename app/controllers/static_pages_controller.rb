class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!
  #filter_access_to :welcome, :require => :read

  def welcome
    if user_signed_in?
    else
      flash[:error] = "Please login first"
      render 'index' unless user_signed_in?
    end
  end

  def index
    if user_signed_in?
      render 'welcome'
    end

  end
end
