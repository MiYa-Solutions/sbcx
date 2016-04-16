# == Schema Information
#
# Table name: org_to_roles
#
#  id                   :integer          not null, primary key
#  organization_id      :integer
#  organization_role_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class OrgToRole < ActiveRecord::Base
  belongs_to :organization
  belongs_to :organization_role

  validates_uniqueness_of :organization_role_id, :scope => :organization_id,
                          :message                      => "can only register once per organization"


end
