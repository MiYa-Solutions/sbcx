class MyUsersController < ApplicationController
  before_filter :authenticate_user!

  filter_access_to :update, attribute_check: true, model: User
  filter_access_to :show
  filter_access_to :edit, attribute_check: true, model: User
  filter_access_to :new
  filter_access_to :index
  filter_access_to :all


  def index
    if params[:search].nil?
      @users = current_user.organization.users.paginate(page: params[:page], per_page: 10)
    else
      @users = User.colleagues(current_user.organization.id).search(params[:search]).paginate(page: params[:page], per_page: 10)
    end
  end


  def new
    @my_user = current_user.organization.users.new
  end

  def create
    @my_user = current_user.organization.users.new(params[:user])

    if @my_user.save
      flash[:success] = t('user.flash.created_successfully')
      redirect_to my_users_path
    else
      render 'new'
    end

  end

  def edit
    @my_user = current_user.organization.users.find(params[:id])

  end

  def update
    @my_user      = current_user.organization.users.find(params[:id])
    @organization = current_user.organization
    if @my_user.update_attributes(params[:user])
      flash[:success] = t('user.flash.updated_successfully')
      redirect_to my_user_path
    else
      render :edit
    end

  end

  def show
    @my_user = current_user.organization.users.find(params[:id])
  end
end
