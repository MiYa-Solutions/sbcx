class AppointmentsController < ApplicationController

  filter_resource_access

  def index
    @appointments = Appointment.my_appointments(current_user.organization_id, params[:start], params[:end]).all
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @appointments }
      format.js { render :json => @appointments }
    end
  end

  # GET /Appointments/1
  # GET /Appointments/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @appointment }
      format.js { render :json => @appointment.to_json }
    end
  end

  # GET /Appointments/new
  # GET /Appointments/new.xml
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @appointment }
      format.json { render :json => @appointment }
    end
  end

  # GET /Appointments/1/edit
  def edit
  end

  # POST /Appointments
  # POST /Appointments.xml
  def create

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to(@appointment, :notice => 'Appointment was successfully created.') }
        format.mobile { redirect_to(@appointment.appointable, :notice => 'Appointment was successfully created.') }
        format.js {}
      else
        format.html { render :action => "new" }
        format.mobile { render :action => "new" }
        format.js {}
      end
    end
  end

  # PUT /Appointments/1
  # PUT /Appointments/1.xml
  # PUT /Appointments/1.js
  def update

    respond_to do |format|
      if @appointment.update_attributes(permitted_params(@appointment).appointment)
        format.html { redirect_to(@appointment, :notice => 'Appointment was successfully updated.') }
        format.mobile { redirect_to(@appointment.appointable, :notice => 'Appointment was successfully updated.') }
        format.js {  }
      else
        format.html { render :edit }
        format.mobile { render :new }
        format.js { render :create }
      end
    end
  end

  # DELETE /Appointments/1
  # DELETE /Appointments/1.xml
  def destroy
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to(@appointment.appointable) }
    end
  end

  def new_appointment_from_params
    if params[:appointment].nil?
      redirect_to user_root_path
    end
    @appointment                 = Appointment.new(permitted_params(@appointment).appointment)
    @appointment.organization_id = current_user.organization_id
  end

end