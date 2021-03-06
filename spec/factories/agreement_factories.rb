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
      # todo adding a user to an organization that has users creates a stack overflow - need to ensure that a user is created at the org factory level
      # agr.organization.users << FactoryGirl.build(:user, organization: agr.organization) if agr.organization.users.empty? && agr.organization.member?
      # agr.counterparty.users << FactoryGirl.build(:user, organization: agr.counterparty) if agr.counterparty.users.empty? && agr.counterparty.member?
      agr.organization.save! if agr.organization.id.nil?
      agr.counterparty.save! if agr.counterparty.id.nil?
      if agr.organization.member?
        agr.creator = agr.organization.users.first
      else
        agr.creator = agr.counterparty.users.first
      end
      agr.save!
      agr.organization.subcontractors << agr.counterparty unless agr.organization.subcontractors.include?(agr.counterparty)
      agr.counterparty.providers << agr.organization unless agr.organization.providers.include?(agr.organization)
    end
  end
  factory :profit_split_agreement, class: SubcontractingAgreement do
    association :organization, factory: :member_org, strategy: :build
    association :counterparty, factory: :member_org, strategy: :build
    sequence(:name) { |n| "Subcontracting PF Agreement #{n}" }
    description Faker::Lorem.paragraph(1)
    starts_at Time.zone.now
    ends_at 1.year.from_now

    after(:build) do |agr|
      agr.posting_rules << FactoryGirl.build(:profit_split_rule, agreement: agr)
      # agr.organization.users << FactoryGirl.build(:user, organization: agr.organization)
      agr.creator = agr.organization.users.first
      agr.save!
      agr.organization.subcontractors << agr.counterparty unless agr.organization.subcontractors.include?(agr.counterparty)
      agr.counterparty.providers << agr.organization unless agr.organization.providers.include?(agr.organization)
    end
  end

  factory :local_subcon_agr, class: SubcontractingAgreement do
    association :organization, factory: :member_org, strategy: :build
    association :counterparty, factory: :local_subcon, strategy: :build
    sequence(:name) { |n| "Subcontracting PF Agreement #{n}" }
    description Faker::Lorem.paragraph(1)
    starts_at Time.zone.now
    ends_at 1.year.from_now

    after(:build) do |agr|
      agr.posting_rules << FactoryGirl.build(:profit_split_rule, agreement: agr)
      # agr.organization.users << FactoryGirl.build(:user, organization: agr.organization)
      agr.creator = agr.organization.users.first
      agr.save!
      agr.organization.subcontractors << agr.counterparty unless agr.organization.subcontractors.include?(agr.counterparty)
      agr.counterparty.providers << agr.organization unless agr.organization.providers.include?(agr.organization)
    end
  end

  factory :agreement_for_subcon, class: SubcontractingAgreement do
    association :organization, factory: :member_org, strategy: :build
    association :counterparty, factory: :member_org, strategy: :build
    sequence(:name) { |n| "Subcon Agreement #{n}" }
    description Faker::Lorem.paragraph(1)
    starts_at Time.zone.now
    ends_at 1.year.from_now

    after(:build) do |agr|
      agr.posting_rules << FactoryGirl.build(:flat_fee_rule, agreement: agr)
      #agr.counterparty.users << FactoryGirl.build(:user, organization: agr.counterparty)
      agr.creator = agr.counterparty.users.first
      agr.save!
      agr.counterparty.providers << agr.organization unless agr.organization.providers.include?(agr.organization)
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

  factory :profit_split_rule, class: ProfitSplit do
    association :agreement, factory: :subcon_agreement
    rate 50.0
    rate_type :percentage
    cheque_rate 1.0
    cheque_rate_type :percentage
    cash_rate 1.0
    cash_rate_type :percentage
    credit_rate 1.0
    credit_rate_type :percentage
    amex_rate 1.0
    amex_rate_type :percentage
    type "ProfitSplit"

  end
end