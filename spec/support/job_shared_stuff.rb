shared_context 'basic job testing' do

  let(:user) { FactoryGirl.build(:user) }
  let(:org) { user.organization }
  let(:job) { FactoryGirl.build(:my_job, organization: org) }
  let(:org_admin) { org.users.admins.first }

  def add_bom_to_job(ticket, cost = nil, price = nil, quantity = nil, buyer = nil, material = nil)
    cost     ||= 10
    price    ||= 100
    quantity ||= 1
    buyer    ||= ticket.organization
    material ||= FactoryGirl.build(:mem_material, organization: ticket.organization)

    ticket.boms << FactoryGirl.build(:ticket_bom,
                                     ticket:   ticket,
                                     material: material,
                                     cost:     cost,
                                     price:    price,
                                     quantity: quantity,
                                     buyer:    buyer)
  end

  def event_permitted_for_job?(state_machine_name, event_name, user, job)
    params = ActionController::Parameters.new({ service_call: {
        "#{state_machine_name}_event".to_sym => event_name
    } })
    p      = PermittedParams.new(params, user, job)
    p.service_call.include?("#{state_machine_name}_event")
  end

end

shared_context 'transferred job' do
  include_context 'basic job testing' unless example.metadata[:skip_basic_job]
  let(:subcon_agr) { FactoryGirl.build(:subcon_agreement, organization: job.organization) }
  let(:subcon) { subcon_agr.counterparty }
  let(:subcon_admin) do
    u = FactoryGirl.build(:user, organization: subcon)
    subcon.users << u
    u
  end
  let(:subcon_job) { TransferredServiceCall.find_by_organization_id_and_ref_id(subcon.id, job.ref_id) }


end

shared_context 'job transferred to local subcon' do
  include_context 'basic job testing' unless example.metadata[:skip_basic_job]
  let(:subcon) { FactoryGirl.build(:local_org) }
  let(:subcon_agr) { FactoryGirl.build(:subcon_agreement, organization: job.organization, counterparty: subcon) }

end

shared_context 'job transferred from a local provider' do
  let(:collect?) { defined?(collection_allowed?) && collection_allowed? ? true : false }
  let(:can_transfer?) { defined?(transfer_allowed?) && transfer_allowed? ? true : false }

  include_context 'basic job testing'
  let(:provider) { FactoryGirl.build(:local_org) }
  let(:job) { FactoryGirl.build(:transferred_job,
                                organization:     org,
                                provider:         provider.becomes(Provider),
                                allow_collection: collect?,
                                transferable:     can_transfer?) }

end

def transfer_the_job
  subcon_agr.save!
  job.save!
  job.update_attributes(subcontractor:    subcon.becomes(Subcontractor),
                        properties:       { 'subcon_fee' => '100', 'bom_reimbursement' => 'true' },
                        subcon_agreement: subcon_agr,
                        status_event:     'transfer')
end

shared_context 'when canceling the job' do
  before do
    job_to_cancel.update_attributes(status_event: 'cancel') unless example.metadata[:skip_cancel]
  end

  it 'should allow to cancel the job', skip_cancel: true do
    expect(job_to_cancel.status_events).to include(:cancel)
  end
end

shared_examples 'provider job is canceled' do
  it 'job status should be canceled' do
    expect(job.reload).to be_canceled
  end
end

shared_examples 'subcon job is canceled' do

  it 'subcon job status should be canceled' do
    expect(subcon_job.reload).to be_canceled
  end
end

shared_context 'when the subcon cancels the job' do
  include_context 'when canceling the job' do
    let(:job_to_cancel) { subcon_job }
  end
end

shared_context 'when the provider cancels the job' do
  include_context 'when canceling the job' do
    let(:job_to_cancel) { job }
  end
end

shared_examples 'provider job canceled after completion' do
  pending 'verify reimbursement'
end

shared_examples 'subcon job canceled after completion' do
  pending 'verify reimbursement'
end

