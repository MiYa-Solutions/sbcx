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
      format.html   # new.html.erb
      format.mobile # new.mobile.erb
      format.js     # new.js.erb
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
      if @bom.ticket.can_change_boms? && @bom.save
        format.html { redirect_to service_call_path(@bom.ticket.id), notice: 'Bom was successfully created.' }
        format.mobile { redirect_to service_call_path(@bom.ticket.id), notice: 'Bom was successfully created.' }
        format.js {}
        format.json { render json: @bom, status: :created, location: @bom }
      else

        format.html do
          @bom.ticket.errors.add :boms, I18n.t('general.job.errors.can_add_bom')
          render :new
        end

        format.mobile do
          @ticket = @bom.ticket
          render :new
        end
        format.json do
          @bom.errors.add :ticket, I18n.t('general.job.errors.can_add_bom')
          render json: @bom.errors, status: :unprocessable_entity
        end
        format.js {}
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
        format.mobile { redirect_to @bom.ticket.becomes(@bom.ticket.class.superclass), notice: 'Bom was successfully updated.' }
        format.json { render :json => @bom, status: :ok }
      else
        format.html { render action: "edit" }
        format.mobile { render action: "edit" }
        format.json { render json: @bom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boms/1
  # DELETE /boms/1.json
  def destroy
    @bom = Bom.find(params[:id])
    begin
      @bom.destroy
    rescue ActiveRecord::RecordInvalid

    end


    respond_to do |format|
      format.html { redirect_to service_call_boms_url }
      format.mobile { redirect_to @bom.ticket }
      format.js
      format.json { head :no_content }
    end
  end

  def new_bom_from_params
    @service_call = ServiceCall.find(params[:service_call_id])
    @bom          ||= @service_call.boms.build(permitted_params(nil).bom)
  end

end
