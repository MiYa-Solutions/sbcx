FactoryGirl.define do
  factory :my_job, class: MyServiceCall do
    association :organization, factory: :member_org, strategy: :build


    after(:build) do |job|
      job.customer = FactoryGirl.build(:member_customer, organization: job.organization)
      job.provider = job.organization.becomes(Provider)
    end
  end

  factory :member_customer, class: Customer do
    sequence(:name) { |n| "Customer #{n}" }
    association :organization, factory: :member_org, strategy: :build

  end
end

