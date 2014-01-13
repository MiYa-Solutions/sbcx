shared_context 'acceptance tests with a single member' do

  let(:org_admin_user) { FactoryGirl.create(:user) }
  let(:org) { org_admin_user.organization }
  let(:customer) { FactoryGirl.create(:customer, organization: org) }

  before do
    in_browser(:org) do
      sign_in org_admin_user
    end
  end

  subject { page }
end

shared_context 'acceptance tests with two members' do |agreement_method, payment_rules|
  include_context 'acceptance tests with a single member'

  let(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let(:org2) { org_admin_user2.organization }
  let!(:agreement) { send(agreement_method, org, org2, payment_rules) }

  let(:org1_org2_acc) { Account.for_affiliate(org, org2).first }
  let(:org2_org1_acc) { Account.for_affiliate(org2, org).first }


  before do

    in_browser(:org2) do
      sign_in org_admin_user2
    end
  end

end

shared_context 'create job and transfer to org2' do
  let(:job) { create_my_job(org_admin_user, customer, :org) }
  let(:subcon_job) { Ticket.last }

  before do
    in_browser(:org) do
      visit service_call_path(job)
      transfer_job job, org2
    end
  end
end