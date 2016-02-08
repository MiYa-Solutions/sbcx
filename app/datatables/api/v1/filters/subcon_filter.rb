class Api::V1::Filters::SubconFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :subcon_id

  def initialize(scope, req_params)
    @orig_scope = scope
    @params     = req_params
    @subcon_id  = params[:filters] ? params[:filters][:subcontractor_id] : nil
  end



  def scope
    if subcon_id.present?
      orig_scope.where('subcontractor_id = ?', subcon_id)
    else
      orig_scope
    end
  end

end