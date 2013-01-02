require 'declarative_authorization/maintenance'
include Authorization::TestHelper

FactoryGirl.define do

  factory :org, class: Organization do
    sequence(:name) { |n| "Organization #{n}" }
    sequence(:email) { |n| "org_person_#{n}@example.com" }

    factory :supplier, class: Supplier do
      the_role = OrganizationRole.find_by_id(OrganizationRole::SUPPLIER_ROLE_ID)
      organization_roles [the_role]
    end

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
      sup_role  = OrganizationRole.find_by_id(OrganizationRole::SUPPLIER_ROLE_ID)
      organization_roles [prov_role, sub_role, sup_role]
    end

    factory :org_with_providers, class: Organization do
      the_role = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
      organization_roles [the_role]

      after(:build) do |org|
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


    after(:build) do |member|
      member.make_member
      member.customers << Customer.new(name: Faker::Name.name)
      FactoryGirl.create_list(:admin, 1, organization: member)
      member.save
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
    association :organization, factory: :all_roles
    sequence(:email) { |n| "org_admin_#{n}@example.com" }
    first_name Faker::Name.name
    password "foobar"
    password_confirmation "foobar"
    the_roles = [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME)]
    roles the_roles
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

  factory :local_provider_customer, class: Customer do
    association :organization, factory: :provider
    name Faker::Name.name
  end

  factory :service_call, class: TransferredServiceCall do
    association :organization, factory: :member
    association :subcontractor
    association :provider

    notes Faker::Lorem.sentence

  end

  factory :transferred_sc_with_new_customer, class: TransferredServiceCall do
    association :organization, factory: :member
    association :provider
    new_customer Faker::Name.name
    association :subcontractor
    notes Faker::Lorem.sentence
  end

  factory :my_service_call do
    association :organization, factory: :member

    association :subcontractor

    notes Faker::Lorem.sentence

    after(:build) do |service_call|
      service_call.customer = service_call.organization.customers.first
    end


  end

  factory :service_call_transfer_event do
    association :eventable, factory: :my_service_call
    type ServiceCallTransferEvent
  end

  factory :event do

  end

  factory :technician, class: User do
    association :organization, factory: :member
    sequence(:email) { |n| "technician_test#{n}@example.com" }
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)
    roles [the_role]

  end
  factory :dispatcher, class: User do
    association :organization, factory: :member
    sequence(:email) { |n| "dispatcher_test#{n}@example.com" }
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    password "foobar"
    password_confirmation "foobar"
    the_role = Role.find_by_name(Role::DISPATCHER_ROLE_NAME)
    roles [the_role]

  end

  factory :received_service_call_notification, class: ScReceivedNotification do
    association :notifiable, factory: :service_call

    after(:create) do |notification, evaluator|
      notification.user = FactoryGirl.create(:admin, organization: notification.notifiable.organization)
    end
  end

  factory :material do
    association :organization, factory: :member
    association :supplier
    name Faker::Name.name
    description Faker::Lorem.paragraph(1)
    cost 123.4
    price 254.7
  end

  factory :bom do
    association :material
    quantity 3

    after(:build) do |bom, evaluator|
      bom.ticket = FactoryGirl.build(:my_service_call, organization: bom.material.organization)
    end

  end

  factory :agreement do
    name Faker::Name.name
    description Faker::Lorem.paragraph(1)

    after(:build) do |agr|
      agr.organization = FactoryGirl.create(:member)
      agr.counterparty = FactoryGirl.create(:member)
      agr.creator      = FactoryGirl.create(:org_admin, organization: agr.organization)
    end

    factory :organization_agreement, class: OrganizationAgreement do
    end
    factory :organization_agreement_by_cparty, class: OrganizationAgreement do
      after(:build) do |agr|
        agr.creator = FactoryGirl.create(:org_admin, organization: agr.counterparty)
      end
    end

    factory :subcontracting_agreement, class: SubcontractingAgreement do

    end

  end


end
