class Api::V1::Filters::AffiliateFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :affiliate_id

  def initialize(scope, req_params)
    @orig_scope   = scope
    @params       = req_params
    @affiliate_id = params[:filters] ? params[:filters][:affiliate_id] : nil
  end


  def scope
    if affiliate_id.present?
      orig_scope.where("provider_id = #{affiliate_id} OR subcontractor_id = #{affiliate_id} ")
    else
      orig_scope
    end
  end

end