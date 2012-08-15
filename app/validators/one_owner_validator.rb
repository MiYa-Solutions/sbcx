class OneOwnerValidator < ActiveModel::Validator
  def validate(record)
    record.organization_roles.each do |org_role|
      case org_role.id
        when OrganizationRole::OWNER_ROLE_ID
          if Organization.joins(:organization_roles).where("organization_roles.id =  #{OrganizationRole::OWNER_ROLE_ID}").length > 0 &&
              Organization.joins(:organization_roles).where("organization_roles.id = #{OrganizationRole::OWNER_ROLE_ID}").first.id != record.id
            record.errors[:base] << I18n.t('errors.messages.one_system_owner')
          end
      end
    end
  end
end