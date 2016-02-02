class Api::V1::Filters::BillingStatusFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :billing_status

  def initialize(scope, req_params)
    @orig_scope = scope
    @params     = req_params
    @billing_status     = params[:filters] ? params[:filters][:billing_status] : nil
  end


  def scope
    if billing_status.present?
      orig_scope.where('billing_status in (?) ', billing_status.map(&:to_i))
    else
      orig_scope
    end
  end


end