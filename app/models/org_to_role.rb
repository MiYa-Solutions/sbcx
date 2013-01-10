# == Schema Information
#
# Table name: org_to_roles
#
#  id                   :integer         not null, primary key
#  organization_id      :integer
#  organization_role_id :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#
# Indexes
#
#  index_org_to_roles_on_organization_id_and_organization_role_id  (organization_id,organization_role_id)
#

class OrgToRole < ActiveRecord::Base
  #validates_presence_of :organization_id, :organization_role_id, message: "both organization_id and organization_role id must be valid"
  belongs_to :organization
  belongs_to :organization_role

  validates_uniqueness_of :organization_role_id, :scope => :organization_id,
                          :message                      => "can only register once per organization"


end
