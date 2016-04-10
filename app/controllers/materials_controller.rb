class MaterialsController < ApplicationController
  filter_access_to :autocomplete_material_name, :require => :index
  filter_resource_access

  autocomplete :material, :name, extra_data: [:cost_cents, :price_cents, :description], full: true, limit: 50, display_value: :name_web

  # GET /materials
  # GET /materials.json
  def index
    if params[:name].nil?
      @materials = Material.search(current_user.organization.id, params[:term])
    else
      @materials = Material.search(current_user.organization.id, params[:name])
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json {
        if params[:name].nil?
          render json: @materials.map(&:name)
        else
          render json: @materials
        end

      }
    end
  end

  # todo - make method either private or move to controller
  def search
    @material = Material.search(current_user.organization.id, params[:name])
    respond_to do |format|
      format.jason { randar jason: @material }
    end
  end


  # GET /materials/1
  # GET /materials/1.json
  def show
    @material = Material.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @material }
    end
  end

  # GET /materials/new
  # GET /materials/new.json
  def new
    @material = Material.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @material }
    end
  end

  # GET /materials/1/edit
  def edit
    @material = Material.find(params[:id])
  end

  # POST /materials
  # POST /materials.json
  def create
    respond_to do |format|
      if @material.save
        format.html { redirect_to @material, notice: t('activerecord.messages.material.created_successfully', material: @material.name) }
        format.json { render json: @material, status: :created, location: @material }
        format.js { }
        format.mobile { redirect_to @material, notice: t('activerecord.messages.material.created_successfully', material: @material.name) }
      else
        format.html { render :new }
        format.json { render json: @material.errors, status: :unprocessable_entity }
        format.js { }
        format.mobile { render :new }
      end
    end
  end

  # PUT /materials/1
  # PUT /materials/1.json
  def update
    @material = Material.find(params[:id])

    respond_to do |format|
      if @material.update_attributes(permitted_params(nil).material)
        format.html { redirect_to @material, notice: 'Material was successfully updated.' }
        format.json { head :no_content }
        format.mobile { redirect_to @material, notice: t('activerecord.messages.material.updated_successfully', material: @material.name) }
      else
        format.html { render action: "edit" }
        format.json { render json: @material.errors, status: :unprocessable_entity }
        format.mobile { redirect_to :back }
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material = Material.find(params[:id])
    @material.destroy

    respond_to do |format|
      format.html { redirect_to materials_url }
      format.json { head :no_content }
    end
  end


  protected

  def default_serializer_options
    {root: false}
  end

  # This is required in order to ensure the user doesn't have access to materials of other organizations
  def autocomplete_material_name_where
    "organization_id = #{current_user.organization.id}"
  end

  def new_material_from_params
    if params[:material].nil?
      @material = current_user.organization.materials.new
    else
      @material = current_user.organization.materials.build(permitted_params(nil).material)
    end
    # todo change to support 3rd party suppliers
    @material.supplier = current_user.organization.becomes(Supplier)

  end


end
