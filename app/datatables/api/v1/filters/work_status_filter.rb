class Api::V1::Filters::WorkStatusFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :work_status

  def initialize(scope, req_params)
    @orig_scope = scope
    @params     = req_params
    @work_status     = params[:filters] ? params[:filters][:work_status] : nil
  end


  def scope
    if work_status.present?
      orig_scope.where('work_status in (?) ', work_status.map(&:to_i))
    else
      orig_scope
    end
  end


end