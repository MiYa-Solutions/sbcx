module MyUsersHelper
  def applicable_user_roles
    roles = []
    Role.all.each do |role|
      case role.name
        when Role::ADMIN_ROLE_NAME
          if current_user.organization.organization_role_ids.in? [OrganizationRole::OWNER_ROLE_ID]
            roles << role
            logger.debugger "User organization is Owner"
          end
        else
          roles << role
      end
    end
    roles
  end
end
