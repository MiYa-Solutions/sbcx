# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer          not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  properties     :hstore
#  time_bound     :boolean          default(FALSE)
#  sunday         :boolean          default(FALSE)
#  monday         :boolean          default(FALSE)
#  tuesday        :boolean          default(FALSE)
#  wednesday      :boolean          default(FALSE)
#  thursday       :boolean          default(FALSE)
#  friday         :boolean          default(FALSE)
#  saturday       :boolean          default(FALSE)
#  sunday_from    :time
#  monday_from    :time
#  tuesday_from   :time
#  wednesday_from :time
#  thursday_from  :time
#  friday_from    :time
#  saturday_from  :time
#  sunday_to      :time
#  monday_to      :time
#  tuesday_to     :time
#  wednesday_to   :time
#  thursday_to    :time
#  friday_to      :time
#  saturday_to    :time
#

require 'spec_helper'

describe ProfitSplit do

  let!(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org_admin_user3) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org) { org_admin_user.organization }
  let!(:org2) {
    setup_profit_split_agreement(org_admin_user2.organization, org.becomes(Subcontractor))
    setup_profit_split_agreement(org, org_admin_user2.organization.becomes(Subcontractor)).counterparty
  }
  let!(:org3) do
    setup_profit_split_agreement(org_admin_user3.organization, org_admin_user.organization.becomes(Subcontractor))
    setup_profit_split_agreement(org2, org_admin_user3.organization.becomes(Subcontractor)).counterparty
  end

  let(:rule) { org.agreements.where(counterparty_id: org2.id).first.posting_rules.first }
  let(:job) { FactoryGirl.create(:my_service_call, organization: org, subcontractor: nil) }
  subject { rule }

  it "should have only percentage as an option" do
    rule.rate_types.should == [:percentage]
  end

  describe 'accounting entries' do

    let(:bom1_cost) { 53.49 }
    let(:bom1_price) { 153 }
    let(:bom1_qty) { 2 }

    let(:bom2_cost) { 0.49 }
    let(:bom2_price) { 0.75 }
    let(:bom2_qty) { 1 }

    before do
      job.technician = FactoryGirl.create(:technician, organization: job.organization)
      job.creator    = job.organization.users.first
      job.dispatch_work if defined? job.dispatch_work
      job.start_work

      add_bom_to_ticket(job, cost: bom1_cost, price: bom1_price, quantity: bom1_qty, buyer: job.organization)
      add_bom_to_ticket(job, cost: bom2_cost, price: bom2_price, quantity: bom2_qty, buyer: job.organization)

    end


    let(:completed_event) do

      job.events.last
    end

    describe 'no transfer' do

      before do
        job.complete_work
      end

      let(:entries) { rule.get_entries(job.events.last) }

      it "should not create accounting entries" do
        entries.should be_empty
      end
      describe "ticket owner is the provider" do
        it "should have a PaymentToSubcontractor entry with the correct amount" do
          entries.should include
        end
      end
    end

  end

  describe "validation" do

    it { should validate_numericality_of(:rate) }

  end

  describe "associations" do
    it { should belong_to(:agreement) }
  end

  describe 'methods' do

  end

end
