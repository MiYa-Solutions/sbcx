class Agreement < ActiveRecord::Base
  belongs_to :provider, :class_name => 'Organization'
  belongs_to :subcontractor, :class_name => 'Organization'
end
