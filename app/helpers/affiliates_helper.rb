module AffiliatesHelper
  def applicable_roles
    roles = []
    OrganizationRole.all.each do |role|
      unless [OrganizationRole::OWNER_ROLE_ID, OrganizationRole::SUPPLIER_ROLE_ID].include? role.id
        roles << role
      end
    end
    roles
  end

  def affiliates
    current_user.organization.providers + current_user.organization.subcontractors
  end

  def affiliate_ids
    current_user.organization.provider_ids + current_user.organization.subcontractor_ids

  end

  def add_affiliate_form

  end


end
