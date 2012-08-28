class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!
  #filter_access_to :welcome, :require => :read

  def welcome
    unless user_signed_in?
      flash[:error] = "Please login first"
      render 'index'
    end
  end

  def index
  end
end
