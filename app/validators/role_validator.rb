class RoleValidator < ActiveModel::Validator

  def validate(record)
    record.roles.each do |role|
      case role.name
        when Role::ADMIN_ROLE_NAME # ensure a user is not associated with an admin unless its org is the owner
          record.errors[:roles] << I18n.t('activerecord.user.errors.messages.admin_role') unless record.organization.organization_roles.include? OrganizationRole.find(OrganizationRole::OWNER_ROLE_ID)
      end

    end
  end

end