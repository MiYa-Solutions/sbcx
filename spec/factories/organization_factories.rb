FactoryGirl.define do

  factory :local_org, class: Organization do
    sequence(:name) { |n| "Organization #{n}" }
    sequence(:email) { |n| "org_person_#{n}@example.com" }
    organization_roles [OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID), OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)]
    industry Organization.industries.first

    factory :member_org, class: Organization do
      subcontrax_member true
      #after(:build) do |org|
      #  org.users << FactoryGirl.build(:user, organization: org)
      #end
    end

    factory :affiliate, class: Affiliate do

    end
  end

  factory :user do
    association :organization, factory: :member_org
    sequence(:email) { |n| "org_admin_#{n}@example.com" }
    first_name Faker::Name.name
    password "foobar"
    password_confirmation "foobar"
    the_roles = [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME)]
    roles the_roles
  end

  factory :additional_user, class: User do
    sequence(:email) { |n| "org_admin_#{n}@example.com" }
    first_name Faker::Name.name
    password "foobar"
    password_confirmation "foobar"
    the_roles = [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME)]
    roles the_roles
  end

end