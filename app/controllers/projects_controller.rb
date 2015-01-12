class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  filter_access_to :autocomplete_project_name, :require => :index
  filter_resource_access

  autocomplete :project, :name, limit: 50, full: true

  # GET /projects
  # GET /projects.json
  def index
    respond_to do |format|
      format.html
      format.mobile
      format.json { render json: ProjectsDatatable.new(view_context).as_json }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.mobile # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.mobile # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    respond_to do |format|
      if @project.save
        format.any(:html, :mobile) { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.any(:html, :mobile) { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update_attributes(project_params)
        format.any(:html, :mobile) { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.any(:html, :mobile) { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def autocomplete_project_name_where
    "organization_id = #{current_user.organization.id}"
  end


  def new_project_from_params
    if params[:project]
      @project = Project.new(project_params)
    else
      @project = Project.new
    end
    @project.organization = current_user.organization
    @project
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def project_params
    params.require(:project).permit(:name,
                                    :description,
                                    :customer_id,
                                    :customer_name,
                                    :provider_id,
                                    :provider_agreement_id,
                                    :status,
                                    :end_date,
                                    :start_date,
                                    :external_ref)
  end

end
