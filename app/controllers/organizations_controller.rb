class OrganizationsController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access

  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  def create

    #@organization = Organization.new(params[:organization])

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
      @users = @organization.users
    else
      redirect_to profile_path
    end

  end

  def index
    @organizations = Organization.paginate(page: params[:page], per_page: 10)
  end

  def edit
    #@organization = Organization.find(params[:id])
  end

  def update
    #@organization = Organization.find(params[:id])
    if @organization.update_attributes(permitted_params(nil).organization)
      respond_to do |format|
        format.js { }
        format.html do
          flash[:success] = "Profile updated"
          render 'registrations/show'
        end
      end
    else
      render 'registrations/edit'
    end

  end

  # needed to combine declarative_authorization with strong parameters
  def new_organization_from_params
    @organization ||= Organization.new(permitted_params(nil).organization)
  end


end


