FactoryGirl.define do
  factory :my_job, class: MyServiceCall do
    association :organization, factory: :member_org, strategy: :build


    after(:build) do |job|
      job.customer = FactoryGirl.build(:member_customer, organization: job.organization)
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
  end

  factory :member_customer, class: Customer do
    sequence(:name) { |n| "Customer #{n}" }
    association :organization, factory: :member_org, strategy: :build

  end
end

