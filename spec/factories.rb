FactoryGirl.define do

  factory :org, class: Organization do
    sequence(:name) { |n| "Organization #{n}" }

    factory :provider do |prov|
      the_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
      organization_role_ids [the_role.id]
    end
  end

  factory :org_admin, class: User do
    association :organization, factory: :provider
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME)
    role_ids [the_role.id]
  end
end