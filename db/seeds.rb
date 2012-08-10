# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


OrganizationRole.find_or_create_by_id_and_name(id: OrganizationRole::PROVIDER_ROLE_ID, name: OrganizationRole::PROVIDER_ROLE_NAME)
OrganizationRole.find_or_create_by_id_and_name(id: OrganizationRole::SUBCONTRACTOR_ROLE_ID, name: OrganizationRole::SUBCONTRACTOR_ROLE_NAME)
OrganizationRole.find_or_create_by_id_and_name(id: OrganizationRole::OWNER_ROLE_ID, name: OrganizationRole::OWNER_ROLE_NAME)

Role.find_or_create_by_name(Role::ADMIN_ROLE_NAME)
Role.find_or_create_by_name(Role::ORG_ADMIN_ROLE_NAME)
Role.find_or_create_by_name(Role::DISPATCHER_ORG_NAME)
Role.find_or_create_by_name(Role::TECHNICIAN_ROLE_NAME)

owner_org = Organization.find_by_email('info@miyasolutions.com')
if owner_org.nil?
  owner_org = Organization.new(email: 'info@miyasolutions.com', name: 'MiYa Solutions LLC')
  owner_org.organization_roles << OrganizationRole.find(OrganizationRole::OWNER_ROLE_ID)
  owner_org.save

  ishay = owner_org.users.new(email: 'ishay@miyasolutions.com', password: '123456', :password_confirmation => '123456')
  mark = owner_org.users.new(email: 'mark@miyasolutions.com', password: '123456', :password_confirmation => '123456')
  ishay.roles << Role.find_by_name("Admin")
  mark.roles << Role.find_by_name("Admin")

  owner_org.save
  ishay.save
  mark.save
end



