class Agreement < ActiveRecord::Base

  attr_accessible :provider_id, :subcontractor_id

  belongs_to :provider, class_name: "Organization"
  belongs_to :subcontractor, class_name: "Organization"

  validates :provider, presence: true
  validates :subcontractor, presence: true

end
