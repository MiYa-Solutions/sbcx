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
  include_context 'basic job testing'
  let(:subcon_agr) { FactoryGirl.build(:subcon_agreement, organization: job.organization) }
  let(:subcon) { subcon_agr.counterparty }
  let(:subcon_admin) do
    u = FactoryGirl.build(:user, organization: subcon)
    subcon.users << u
    u
  end
  let(:subcon_job) { TransferredServiceCall.find_by_organization_id_and_ref_id(subcon.id, job.ref_id) }

  def transfer_the_job
    subcon_agr.save!
    job.save!
    job.update_attributes(subcontractor:    subcon.becomes(Subcontractor),
                          properties:       { 'subcon_fee' => '100', 'bom_reimbursement' => 'true' },
                          subcon_agreement: subcon_agr,
                          status_event:     'transfer')
  end

end