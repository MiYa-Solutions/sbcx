class CustomerImportsController < ApplicationController

  filter_resource_access

  # GET /job_imports/new
  # GET /job_imports/new.json
  def new
    @customer_import = CustomerImport.new(current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_import }
    end
  end

  # POST /job_imports
  # POST /job_imports.json
  def create
    @customer_import = CustomerImport.new(current_user, import_params)

    respond_to do |format|
      if @customer_import.save
        flash.now[:success] = @customer_import.import_summary.html_safe
        format.html { render action: 'new'}
        format.json { render json: @customer_import, status: :created, location: @customer_import }
      else
        flash.now[:error] = @customer_import.import_summary.html_safe
        format.html { render action: 'new' }
        format.json { render json: @customer_import.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def new_customer_import_from_params
    @customer_import = CustomerImport.new(current_user)
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def import_params
    params[:customer_import][:klass] = 'Customer'
    params.require(:customer_import).permit(:file, :klass)
  end
end
