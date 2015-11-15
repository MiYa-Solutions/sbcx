class CustomerImportsController < ApplicationController

  filter_resource_access

  # GET /job_imports/new
  # GET /job_imports/new.json
  def new
    @import = RecordsImport.new(current_user, klass: Customer)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job_import }
    end
  end

  # POST /job_imports
  # POST /job_imports.json
  def create
    @import = RecordsImport.new(current_user, import_params)

    respond_to do |format|
      if @job_import.save
        flash[:success] = 'Jobs succesfully imported imported '
        format.html { render action: 'new'}
        format.json { render json: @job_import, status: :created, location: @job_import }
      else
        format.html { render action: 'new' }
        format.json { render json: @job_import.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def new_customer_import_from_params
    @import = RecordsImport.new(current_user, klass: Customer)
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def import_params
    params[:klass] = Customer
    params.require(:import).permit(:file, :klass)
  end
end
