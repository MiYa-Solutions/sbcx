# == Schema Information
#
# Table name: organization_roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# == Schema Information
#
# Table name: organization_roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
# TODO refactor role to use I18n as well as not save the name in the database
class OrganizationRole < ActiveRecord::Base
  attr_accessible :name, :id
  self.primary_key= :id
  #set_primary_key :id
  has_many :org_to_roles
  has_many :organizations, through: :org_to_roles

  OWNER_ROLE_ID      = 0
  OWNER_ROLE_NAME    = 'System Owner'
  PROVIDER_ROLE_ID   = 1
  PROVIDER_ROLE_NAME = 'Provider'

  SUBCONTRACTOR_ROLE_ID   = 2
  SUBCONTRACTOR_ROLE_NAME = 'Subcontractor'

  SUPPLIER_ROLE_ID   = 3
  SUPPLIER_ROLE_NAME = 'Supplier'

end
