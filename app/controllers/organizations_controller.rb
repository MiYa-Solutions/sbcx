class OrganizationsController < ApplicationController

  #before_filter :authenticate_user!
  filter_resource_access

  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organizationer }
    end
  end

  def create

    @organization = Organization.new(params[:organization])

    if @organization.save
      flash[:success] = "Organization Created Successfully"
      redirect_to @organization
    else
      render 'new'
    end
  end

  def show
    if has_role? :admin
      @organization = Organization.find(params[:id])
    else
      @organization = current_user.organization
    end

    @users = @organization.users


  end

  def index
    @organizations = Organization.paginate(page: params[:page], per_page: 2)
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(params[:organization])
      flash[:success] = "Profile updated"
      redirect_to @organization
    else
      render 'edit'
    end
  end

end
