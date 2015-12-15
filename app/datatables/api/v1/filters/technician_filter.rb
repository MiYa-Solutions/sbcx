class Api::V1::Filters::TechnicianFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :technician_id

  def initialize(scope, req_params)
    @orig_scope = scope
    @params     = req_params
    @technician_id  = params[:filters] ? params[:filters][:technician_id] : nil
  end



  def scope
    if technician_id.present?
      orig_scope.where('technician_id = ?', technician_id)
    else
      orig_scope
    end
  end

end