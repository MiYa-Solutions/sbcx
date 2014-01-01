FactoryGirl.define do
  factory :subcon_agreement, class: SubcontractingAgreement do
    association :organization, factory: :member_org, strategy: :build
    association :counterparty, factory: :member_org, strategy: :build
    sequence(:name) { |n| "Subcontracting Agreement #{n}" }
    description Faker::Lorem.paragraph(1)
    starts_at Time.zone.now
    ends_at 1.year.from_now

    after(:build) do |agr|
      agr.posting_rules << FactoryGirl.build(:flat_fee_rule, agreement: agr)
      agr.creator = agr.organization.users.first
      agr.save!
      agr.organization.subcontractors << agr.counterparty
      agr.counterparty.providers << agr.organization
    end
  end

  factory :flat_fee_rule, class: FlatFee do
    association :agreement, factory: :subcon_agreement
    rate nil
    rate_type nil
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
end