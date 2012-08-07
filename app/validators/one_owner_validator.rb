class OneOwnerValidator < ActiveModel::Validator
  def validate(record)
    record.organization_roles.each do |org_role|
      case org_role.id
        when OrganizationRole::OWNER_ROLE_ID
          if OrgToRole.where('organization_role_id = ?', OrganizationRole::OWNER_ROLE_ID).exists?
            record.errors[:base] << I18n.t('errors.messages.one_system_owner')
          end
      end
    end
  end
end