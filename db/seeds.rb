# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

OrganizationRole.find_or_create_by_id_and_name(id: OrganizationRole::PROVIDER_ROLE_ID, name: OrganizationRole::PROVIDER_ROLE_NAME)
OrganizationRole.find_or_create_by_id_and_name(id: OrganizationRole::SUBCONTRACTOR_ROLE_ID, name: OrganizationRole::SUBCONTRACTOR_ROLE_NAME)

Role.find_or_create_by_name("Admin")
Role.find_or_create_by_name("Org Admin")
Role.find_or_create_by_name("Dispatcher")
Role.find_or_create_by_name("Technician")


