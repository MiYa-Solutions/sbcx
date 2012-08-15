FactoryGirl.define do

  factory :org, class: Organization do
    sequence(:name) { |n| "Organization #{n}" }
    sequence(:email) { |n| "org_person_#{n}@example.com" }


    factory :provider, class: Provider do |prov|
      the_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
      organization_roles [the_role]
    end

    factory :org_with_providers, class: Organization do
      the_role = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
      organization_roles [the_role]

      after_build do |org|
        30.times { org.providers << FactoryGirl.create(:provider) }
      end
    end

    factory :member, class: Organization do
      the_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
      organization_roles [the_role]

      after_build do |member|
        member.users << FactoryGirl.build(:admin, organization: member)
        member.make_member
      end
    end

  end

  factory :admin, class: User do
    association :organization, factory: :org
    sequence(:email) { |n| "admin_test#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME)
    roles [the_role]
  end

  factory :org_admin, class: User do
    association :organization, factory: :provider
    sequence(:email) { |n| "org_admin_#{n}@example.com" }
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
