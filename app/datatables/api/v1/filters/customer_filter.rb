class Api::V1::Filters::CustomerFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :customer_id

  def initialize(scope, req_params)
    @orig_scope = scope
    @params = req_params
    @customer_id = params[:filters] ? params[:filters][:customer_id] : nil
  end



  def scope
    if customer_id.present?
      orig_scope.where("customer_id = #{customer_id}")
    else
      orig_scope
    end
  end

end