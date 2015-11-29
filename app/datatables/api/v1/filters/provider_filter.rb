class Api::V1::Filters::ProviderFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :provider_id

  def initialize(scope, req_params)
    @orig_scope = scope
    @params = req_params
    @provider_id = params[:filters] ? params[:filters][:provider_id] : nil
  end



  def scope
    if provider_id.present?
      orig_scope.where('provider_id = ?', provider_id)
    else
      orig_scope
    end
  end

end