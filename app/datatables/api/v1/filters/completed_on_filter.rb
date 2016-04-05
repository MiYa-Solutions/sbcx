class Api::V1::Filters::CompletedOnFilter
  attr_accessor :params
  attr_accessor :orig_scope
  attr_accessor :from_date
  attr_accessor :to_date

  def initialize(scope, req_params)
    @orig_scope = scope
    @params = req_params
    @from_date = params[:filters] ? params[:filters][:completed_from_date] : nil
    @to_date = params[:filters] ? params[:filters][:completed_to_date] : nil
  end



  def scope
    res_scope = orig_scope
    if from_date.present? && !to_date.present?
      res_scope = res_scope.where('completed_on >= ?', Time.zone.parse(from_date))
    end

    if to_date.present? && !from_date.present?
      res_scope = res_scope.where('completed_on <= ?', Time.zone.parse(to_date))
    end

    if to_date.present? && from_date.present?
      res_scope = res_scope.where('completed_on between ? and ?', Time.zone.parse(from_date), Time.zone.parse(to_date))
    end

    res_scope
  end

end