class OrganizationsController < ApplicationController

  before_filter :authenticate_user!

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
      flash[:success] =  "Organization Created Successfully"
      redirect_to @organization
    else
      render 'new'
    end
  end

  def show
    @organization = Organization.find(params[:id])

  end

  def index
    @organizations = Organization.all

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
