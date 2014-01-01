shared_context 'basic job testing' do
  let(:job) { FactoryGirl.build(:my_job) }
  let(:org) { job.organization }
  let(:user) { job.organization.users.first }

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

end

shared_context 'transferred job' do
  include_context 'basic job testing'
  let(:subcon_agr) { FactoryGirl.build(:subcon_agreement, organization: org) }
  let(:subcon) { subcon_agr.counterparty }
  let(:subcon_user) { subcon_agr.counterparty.users.first }
  let(:subcon_job) { TransferredServiceCall.find_by_organization_id_and_ref_id(subcon.id, job.ref_id) }

  def transfer_the_job
    subcon_agr.save!
    job.save!
    job.update_attributes(subcontractor:    subcon.becomes(Subcontractor),
                          subcon_agreement: subcon_agr,
                          status_event:     'transfer')
  end

end