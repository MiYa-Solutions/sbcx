require 'declarative_authorization/maintenance'
include Authorization::TestHelper
require 'support/utilities'

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
      FactoryGirl.create_list(:admin, 1, organization: member, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) unless member.users.count > 0
      member.save
    end
  end
  factory :member_with_no_user, class: Organization do
    sequence(:name) { |n| "Organization Member#{n}" }
    sequence(:email) { |n| "member_person_#{n}@example.com" }

    prov_role = OrganizationRole.find_by_id(OrganizationRole::PROVIDER_ROLE_ID)
    sub_role  = OrganizationRole.find_by_id(OrganizationRole::SUBCONTRACTOR_ROLE_ID)
    organization_roles [prov_role, sub_role]


    after(:build) do |member|
      member.make_member
      member.customers << Customer.new(name: Faker::Name.name)
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
    association :organization, factory: :member_with_no_user
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

    after(:create) do |cus|
      setup_customer_agreement cus.organization, cus
    end
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

    after(:build) do |sc|
      agr = Agreement.org_agreements(sc.provider.id).cparty_agreements(sc.subcontractor.id).with_status(:active).first
      if agr.present?
        sc.provider_agreement = agr
      else
        sc.provider_agreement = setup_profit_split_agreement(sc.provider, sc.organization)
      end

    end

  end

  factory :transferred_sc_with_new_customer, class: TransferredServiceCall do
    association :organization, factory: :member
    association :provider
    customer_name Faker::Name.name
    association :subcontractor
    notes Faker::Lorem.sentence

    after(:build) do |sc|
      agr = Agreement.org_agreements(sc.provider.id).cparty_agreements(sc.subcontractor.id).with_status(:active).first
      if agr.present?
        sc.provider_agreement = agr
      else
        sc.provider_agreement = setup_profit_split_agreement(sc.provider, sc.organization)
      end

    end

  end

  factory :my_service_call do
    association :organization, factory: :member

    association :subcontractor

    email Faker::Internet.email
    name Faker::Name.name
    phone Faker::PhoneNumber.phone_number
    mobile_phone Faker::PhoneNumber.phone_number
    work_phone Faker::PhoneNumber.phone_number
    company Faker::Company.name
    address1 Faker::Address.street_address
    address2 Faker::Address.street_address(true)
    city Faker::Address.city
    state Faker::Address.us_state_abbr
    zip Faker::Address.zip_code
    country "US"


    notes Faker::Lorem.sentence


    after(:build) do |service_call|
      service_call.customer = service_call.organization.customers.first
    end

    factory :completed_service_call, class: MyServiceCall do

      after(:build) do |service_call|
        service_call.technician = FactoryGirl.create(:technician, organization: service_call.organization)
        service_call.creator    = service_call.organization.users.first
        service_call.dispatch_work if defined? service_call.dispatch_work
        service_call.start_work
        add_bom_to_ticket(service_call)
        service_call.complete_work
      end

      factory :paid_service_call, class: MyServiceCall do
        after(:build) do |service_call|
          service_call.paid
        end
      end


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

  factory :new_agreement, class: Agreement do

    name Faker::Name.name
    description Faker::Lorem.paragraph(1)
    association :organization, factory: :member
    association :counterparty, factory: :member

    starts_at Time.zone.now
    ends_at 1.year.from_now


    after(:build) do |agr|
      agr.creator = FactoryGirl.create(:org_admin, organization: agr.organization)
    end

    after(:create) do |agr|
      agr.posting_rules = [FactoryGirl.create(:profit_split, agreement: agr)]
    end

    factory :organization_agreement, class: OrganizationAgreement do
    end


  end

  factory :agreement do
    name Faker::Name.name
    description Faker::Lorem.paragraph(1)
    starts_at Time.zone.now
    ends_at 1.year.from_now

    after(:build) do |agr|
      agr.organization = FactoryGirl.create(:member)
      agr.counterparty = FactoryGirl.create(:member)
      agr.creator      = FactoryGirl.create(:org_admin, organization: agr.organization)
    end

    after(:create) do |agr|
      agr.posting_rules = [FactoryGirl.create(:profit_split, agreement: agr)]
      #agr.status        = OrganizationAgreement::STATUS_ACTIVE
    end


    factory :organization_agreement_by_cparty, class: OrganizationAgreement do
      after(:build) do |agr|
        agr.creator = FactoryGirl.create(:org_admin, organization: agr.counterparty)
      end
    end

    factory :subcontracting_agreement, class: SubcontractingAgreement do

    end

  end

  factory :service_call_completed_event do
    association :eventable, factory: :completed_service_call
  end

  factory :posting_rule do
    association :agreement
    rate nil
    rate_type nil

    factory :flat_fee, class: FlatFee do
      cheque_rate 1.0
      cheque_rate_type :percentage
      cash_rate 1.0
      cash_rate_type :percentage
      credit_rate 1.0
      credit_rate_type :percentage
      amex_rate 1.0
      amex_rate_type :percentage
      type "FlatFee"
    end

    factory :profit_split, class: ProfitSplit do
      rate 50
      cheque_rate 1.0
      cheque_rate_type :percentage
      cash_rate 1.0
      cash_rate_type :percentage
      credit_rate 1.0
      credit_rate_type :percentage
      amex_rate 1.0
      amex_rate_type :percentage

      rate_type "percentage"
      type "ProfitSplit"
    end
  end

  factory :invite do
    association :organization, factory: :member
    association :affiliate, factory: :member
    sequence(:message) { |n| "invite message #{n}" }
  end


end
