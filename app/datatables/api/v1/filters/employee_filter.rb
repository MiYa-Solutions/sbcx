class Api::V1::Filters::EmployeeFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :employee_id

  def initialize(scope, req_params)
    @orig_scope = scope
    @params     = req_params
    @employee_id  = params[:filters] ? params[:filters][:employee_id] : nil
  end



  def scope
    if employee_id.present?
      orig_scope.where('employee_id = ?', employee_id)
    else
      orig_scope
    end
  end

end