FactoryGirl.define do

  factory :local_org, class: Organization do
    sequence(:name) { |n| "Organization#{n}" }
    sequence(:email) { |n| "org_person_#{n}@example.com" }
    the_roles =  [OrganizationRole.find(OrganizationRole::PROVIDER_ROLE_ID), OrganizationRole.find(OrganizationRole::SUBCONTRACTOR_ROLE_ID)]
    industry Organization.industries.first
    organization_roles the_roles

    factory :member_org, class: Organization do
      subcontrax_member true
      after(:build) do |org|
        org.users.build(
            email:                 "u_#{org.email}",
            organization:          org,
            first_name:            Faker::Name.name,
            password:              'SbcxTest123',
            password_confirmation: 'SbcxTest123',
            roles:                 [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME)]
        )
      end

      after(:create) do |org|
        org.organization_roles = []
        org.organization_roles << OrganizationRole.find(OrganizationRole::PROVIDER_ROLE_ID)
        org.organization_roles << OrganizationRole.find(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
      end
    end

    factory :affiliate, class: Affiliate do

    end

    factory :local_provider, class: Provider do

    end

    factory :local_subcon, class: Subcontractor do

    end
  end

  factory :user do
    association :organization, factory: :member_org, strategy: :build
    sequence(:email) { |n| "org_admin_#{n}@example.com" }
    first_name Faker::Name.name
    password 'SbcxTest123'
    password_confirmation 'SbcxTest123'
    the_roles = [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME)]
    roles the_roles
  end

  factory :my_technician, class: User do
    sequence(:email) { |n| "org_technician_#{n}@example.com" }
    first_name Faker::Name.name
    password 'SbcxTest123'
    password_confirmation 'SbcxTest123'
    the_roles = [Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]
    roles the_roles
  end

end