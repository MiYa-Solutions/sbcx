class RegionSelectController < ApplicationController
  def subregion_options
    case params[:form_id]
      when 'new_customer'
        render partial: 'customers/subregion_select'
      when 'new_provider'
        render partial: 'providers/subregion_select'
      when 'new_organization'
        render partial: 'organizations/subregion_select'
      when 'new_subcontractor'
        render partial: 'subcontractors/subregion_select'
      else
        render partial: 'subregion_select'
    end

  end
end
