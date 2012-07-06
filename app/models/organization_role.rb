# == Schema Information
#
# Table name: organization_roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class OrganizationRole < ActiveRecord::Base
  attr_accessible :name, :id
  set_primary_key :id
  has_many :org_to_roles
  has_many :organizations, through: :org_to_roles
end
