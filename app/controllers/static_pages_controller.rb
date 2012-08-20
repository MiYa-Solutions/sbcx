class StaticPagesController < ApplicationController
  #before_filter :authenticate_user!

  def welcome
    render 'welcome'

  end

  def index

  end
end
