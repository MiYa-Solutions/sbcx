# == Schema Information
#
# Table name: agreements
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  subcontractor_id :integer
#  provider_id      :integer
#  description      :text
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Agreement < ActiveRecord::Base

  attr_accessible :provider_id, :subcontractor_id

  belongs_to :provider, class_name: "Provider"
  belongs_to :subcontractor, class_name: "Subcontractor"

  validates :provider, presence: true
  validates :subcontractor, presence: true

end
