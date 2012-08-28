require 'declarative_authorization/maintenance'
include Authorization::TestHelper

FactoryGirl.define do

  factory :org, class: Organization do
    sequence(:name) { |n| "Organization #{n}" }
    sequence(:email) { |n| "org_person_#{n}@example.com" }

    factory :provider, class: Provider do |prov|
      the_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
      organization_roles [the_role]
    end

    factory :subcontractor, class: Subcontractor do
      the_role = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
      organization_roles [the_role]
    end

    factory :all_roles, class: Organization do
      prov_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
      sub_role  = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
      organization_roles [prov_role, sub_role]
    end

    factory :org_with_providers, class: Organization do
      the_role = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
      organization_roles [the_role]

      after_build do |org|
        30.times { org.providers << FactoryGirl.create(:provider) }
      end
    end
  end

  factory :member, class: Organization do
    sequence(:name) { |n| "Organization Member#{n}" }
    sequence(:email) { |n| "member_person_#{n}@example.com" }

    prov_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
    sub_role  = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
    organization_roles [prov_role, sub_role]

    after_build do |member|
      member.make_member
    end
  end

  factory :admin, class: User do
    association :organization, factory: :org
    sequence(:email) { |n| "admin_test#{n}@example.com" }
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME)
    roles [the_role]
  end

  factory :org_admin, class: User do
    association :organization, factory: :provider
    sequence(:email) { |n| "org_admin_#{n}@example.com" }
    first_name Faker::Name.name
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME)
    roles [the_role]
  end

  factory :member_admin, class: User do
    association :organization, factory: :member
    sequence(:email) { |n| "mem_admin_#{n}@example.com" }
    first_name Faker::Name.name
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME)
    roles [the_role]
  end

  factory :owner_admin, class: User do
    organization
    sequence(:email) { |n| "owner_admin_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::ADMIN_ROLE_NAME)
    roles [the_role]
  end

  factory :customer do
    association :organization, factory: :member
    name Faker::Name.name
  end


end
