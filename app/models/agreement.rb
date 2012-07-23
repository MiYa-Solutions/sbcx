class Agreement < ActiveRecord::Base

  attr_accessible :provider_id, :subcontractor_id

  belongs_to :provider, class_name: "Provider"
  belongs_to :subcontractor, class_name: "Subcontractor"

  validates :provider, presence: true
  validates :subcontractor, presence: true

end
