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
#  parent_org_id     :integer
#  industry          :string(255)
#  other_industry    :string(255)
#

class Affiliate < Organization

  def save
    self.parent_org.providers << self if !self.parent_org.providers.include?(self) && self.organization_role_ids.include?(OrganizationRole::PROVIDER_ROLE_ID)
    self.parent_org.subcontractors << self if !self.parent_org.subcontractors.include?(self) && self.organization_role_ids.include?(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
    super
  end

  def invited?(org)
    Invite.where(organization_id: org.id, affiliate_id: self.id).count > 0
  end

  def invites_by_org(org)
    Invite.where(organization_id: org.id, affiliate_id: self.id).all
  end

  def account_for(org)
    Account.for_affiliate(org, self).first
  end

end
