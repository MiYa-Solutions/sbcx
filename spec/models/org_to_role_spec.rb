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

require 'spec_helper'

describe OrgToRole do
  pending "add some examples to (or delete) #{__FILE__}"
end
