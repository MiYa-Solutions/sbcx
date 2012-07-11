class RegionSelectController < ApplicationController
  def subregion_options
    render  partial: 'subregion_select'
  end
end
