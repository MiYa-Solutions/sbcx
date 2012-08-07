FactoryGirl.define do

  factory :org, class: Organization do
    sequence(:name) { |n| "Organization #{n}" }

    factory :provider do |prov|
      the_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
      organization_roles [the_role]
    end
  end

  factory :org_admin, class: User do
    association :organization, factory: :provider
    sequence(:email) { |n| "person_#{n}@example.com" }
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

end
