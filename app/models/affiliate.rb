# == Schema Information
#
# Table name: organizations
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  phone             :string(255)
#  website           :string(255)
#  company           :string(255)
#  address1          :string(255)
#  address2          :string(255)
#  city              :string(255)
#  state             :string(255)
#  zip               :string(255)
#  country           :string(255)
#  mobile            :string(255)
#  work_phone        :string(255)
#  email             :string(255)
#  subcontrax_member :boolean
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Affiliate < Organization

  def save
    self.parent_org.providers << self if self.organization_role_ids.include? OrganizationRole::PROVIDER_ROLE_ID
    self.parent_org.subcontractors << self if self.organization_role_ids.include? OrganizationRole::SUBCONTRACTOR_ROLE_ID
    self.valid?
  end

end
