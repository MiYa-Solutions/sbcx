class Api::V1::Filters::TagsFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :tags

  def initialize(scope, req_params)
    @orig_scope = scope
    @params     = req_params
    @tags  = params[:filters] ? params[:filters][:tags] : nil
  end



  def scope
    if tags.present?
      orig_scope.joins(:tags).where('tags.name in (?)', tags)
    else
      orig_scope
    end
  end

end