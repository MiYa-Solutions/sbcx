class BomsController < ApplicationController

  filter_resource_access


  # GET /boms
  # GET /boms.json
  def index
    @service_call = ServiceCall.find(params[:service_call_id])
    @boms         = @service_call.boms

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boms }
    end
  end

  # GET /boms/1
  # GET /boms/1.json
  def show
    @bom = Bom.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bom }
    end
  end

  # GET /boms/new
  # GET /boms/new.json
  def new
    @ticket = ServiceCall.find(params[:service_call_id]).becomes(ServiceCall)
    @bom    = @ticket.boms.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @bom }
    end
  end

  # GET /boms/1/edit
  def edit
    @bom    = Bom.find(params[:id])
    @ticket = @bom.ticket.becomes(@bom.ticket.class.superclass)

    respond_to do |format|
      format.html # edit.html.erb
      format.js   # edit.js.erb
      format.json { render json: @bom }
    end
  end

  # POST /boms
  # POST /boms.json
  def create

    respond_to do |format|
      if @bom.save
        format.html { redirect_to service_call_path(@bom.ticket.id), notice: 'Bom was successfully created.' }
        format.js { }
        format.json { render json: @bom, status: :created, location: @bom }
      else
        format.html { render :new }
        format.json { render json: @bom.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  # PUT /boms/1
  # PUT /boms/1.json
  def update
    @bom = Bom.find(params[:id])

    respond_to do |format|
      if @bom.update_attributes(permitted_params(@bom).bom)
        format.html { redirect_to [@bom.ticket.becomes(@bom.ticket.class.superclass), @bom], notice: 'Bom was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boms/1
  # DELETE /boms/1.json
  def destroy
    @bom = Bom.find(params[:id])
    @bom.destroy

    respond_to do |format|
      format.html { redirect_to service_call_boms_url }
      format.js
      format.json { head :no_content }
    end
  end

  def new_bom_from_params
    @service_call = ServiceCall.find(params[:service_call_id])
    @bom          ||= @service_call.boms.new(permitted_params(nil).bom)
  end

end
