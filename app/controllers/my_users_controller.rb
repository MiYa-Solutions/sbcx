class MyUsersController < ApplicationController
  def index
  end

  def new
    @my_user = current_user.organization.users.new
  end

  def create
    @my_user = current_user.organization.users.new(params[:user])

    if @my_user.save
      flash[:success] = t('user.flash.created_successfully')
      redirect_to :back
    else
      render 'new'
    end

  end

  def edit
    @my_user = current_user.organization.users.find(params[:id])
  end

  def update
    @my_user = current_user.organization.users.find(params[:id])
    if @my_user.update_attributes(params[:user])
      flash[:success] = t('user.flash.updated_successfully')
      redirect_to my_user_path
    else
      render :edit
    end

  end

  def show
    # todo move to the below to the organization model and use declarative_authorization
    @my_user = current_user.organization.users.find(params[:id])
  end
end
