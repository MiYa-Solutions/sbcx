FactoryGirl.define do
  factory :my_job, class: MyServiceCall do
    association :organization, factory: :member_org, strategy: :build
    scheduled_for 1.day.from_now


    after(:build) do |job|
      job.organization.users << FactoryGirl.build(:user, organization: job.organization) if job.organization.users.size == 0
      User.stamper = job.organization.users.first
      job.customer = FactoryGirl.build(:member_customer, organization: job.organization)
      job.organization.customers << job.customer
      job.provider = job.organization.becomes(Provider)
    end

    factory :my_transferred_job, class: MyServiceCall do
      after(:build) do |job|
        job.subcon_agreement = FactoryGirl.build(:subcon_agreement, organization: job.organization)
        job.subcontractor    = job.subcon_agreement.counterparty.becomes(Subcontractor)
        subcon_agreement.get_transfer_props.map(&:attribute_names).flatten
        job.transfer
      end
    end

    factory :transferred_job, class: SubconServiceCall do
      association :provider, factory: :member_org, strategy: :build
      allow_collection true
      after(:build) do |job|
        prov = FactoryGirl.build(:local_provider)
        job.organization.users.first.save!
        prov.save!
        job.provider_agreement = FactoryGirl.build(:agreement_for_subcon, organization: prov.becomes(Organization), counterparty: job.organization)
        job.provider           = prov
        job.properties         = { 'provider_fee' => '100', 'prov_bom_reimbursement' => 'true' }
      end
    end
  end

  factory :member_customer, class: Customer do
    sequence(:name) { |n| "Customer #{n}" }
    association :organization, factory: :member_org, strategy: :build
  end

  factory :mem_material, class: Material do
    association :organization, factory: :member_org, strategy: :build
    sequence(:name) { |n| "Test Material #{n}" }
    description Faker::Lorem.paragraph(1)
    cost Money.new_with_amount(123.4)
    price Money.new_with_amount(254.7)

    after(:build) do |mat|
      mat.supplier = mat.organization.becomes(Supplier)
    end
  end

  factory :ticket_bom, class: Bom do
    association :material, factory: :mem_material, strategy: :build
    association :ticket, factory: :my_job, strategy: :build
    buyer 'You forgot to specify a buyer when creating the bom'
    quantity 3
    cost Money.new_with_amount 10
    price Money.new_with_amount 100

    after(:build) do |bom|
      bom.ticket.save!
      bom.material.save!
      bom.material_id = bom.material.id
      bom.buyer = bom.ticket.provider unless bom.buyer
    end
  end

  factory :job_from_local, class: SubconServiceCall do
    association :organization, factory: :member_org, strategy: :build
    association :provider, factory: :local_provider, strategy: :build
    scheduled_for 1.day.from_now


    after(:build) do |job|
      job.provider_agreement = FactoryGirl.build(:subcon_agreement, organization: job.provider)
      job.customer           = FactoryGirl.build(:member_customer, organization: job.provider)
      job.provider.customers << job.customer
      job.organization.users << FactoryGirl.build(:user, organization: job.organization) if job.organization.users.size == 0
    end

    factory :local_subcon_job, class: SubconServiceCall

  end

end

