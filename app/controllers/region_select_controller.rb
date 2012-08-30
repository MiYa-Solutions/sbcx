class RegionSelectController < ApplicationController
  def subregion_options
    case params[:form_id]
      when 'new_customer'
        render partial: 'customers/subregion_select'
      when 'edit_customer'
        render partial: 'customers/subregion_select'
      when 'new_provider'
        render partial: 'providers/subregion_select'
      when 'edit_provider'
        render partial: 'providers/subregion_select'
      when 'new_organization'
        render partial: 'organizations/subregion_select'
      when 'edit_organization'
        render partial: 'organizations/subregion_select'
      when 'new_subcontractor'
        render partial: 'subcontractors/subregion_select'
      when 'edit_subcontractor'
        render partial: 'subcontractors/subregion_select'
      when 'edit_user'
        render partial: 'my_users/subregion_select'
      when 'new_user'
        render partial: 'my_users/subregion_select'
      else
        render partial: 'shared/subregion_select'
    end

  end
end
