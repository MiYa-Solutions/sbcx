shared_context 'job methods' do
  def add_bom_to_job(ticket, options = {})

    cost     = options[:cost] || 10
    price    = options[:price] || 100
    quantity = options[:quantity] || 100
    buyer    = options[:buyer] || ticket.organization
    material = options[:material] || FactoryGirl.build(:mem_material, organization: ticket.organization)

    ticket.boms << FactoryGirl.build(:ticket_bom,
                                     ticket:   ticket,
                                     material: material,
                                     cost:     cost,
                                     price:    price,
                                     quantity: quantity,
                                     buyer:    buyer)
  end

  def start_the_job(job)
    job.start_work!
  end

  def dispatch_the_job(job, technician)
    job.technician = technician
    job.dispatch_work!
  end

  def accept_the_job(job)
    job.accept!
  end

  def accept_on_behalf_of_subcon(job)
    job.accept_work!

  end

  def complete_the_work(job)
    job.complete_work!
  end

  def collect_a_payment(job, options = {})
    job.payment_type   = options[:type] || 'cash'
    job.payment_amount = options[:amount] || 0
    job.collector      = options[:collector] || job.organization

    job.collect_payment!
    job.payment_type   = nil
    job.payment_amount = nil
    job.collector      = nil
  end

  def invoice(job)
    job.invoices << Invoice.new(account: job.customer.account, organization: job.organization)
  end

  def confirm_employee_deposit(entry)
    entry.confirm!
  end


  def event_permitted_for_job?(state_machine_name, event_name, user, job)
    params = ActionController::Parameters.new({ service_call: {
                                                  "#{state_machine_name}_event".to_sym => event_name
                                              } })
    p      = PermittedParams.new(params, user, job)
    p.service_call.include?("#{state_machine_name}_event")
  end

  def collect_full_amount(job, options = {})
    type      = options[:type] ? options[:type] : 'cash'
    collector = options[:collector] ? options[:collector] : job.organization

    amount         = job.total - job.paid_amount
    payment_amount = amount > 0 ? amount : nil
    collect_a_payment job, amount: payment_amount, type: type, collector: collector
  end

  def cancel_the_job(ticket)
    ticket.cancel!
  end

  def cancel_the_transfer(ticket)
    ticket.cancel_transfer!
  end

  def reset_the_job(ticket)
    ticket.reset_work!
  end

  def add_technician(the_org, options = {})
    subcon_job.save
    subcon.users << FactoryGirl.build(:my_technician)
  end

  def un_cancel_the_job(ticket)
    ticket.un_cancel!
  end

end

shared_context 'basic job testing' do

  let(:org) { FactoryGirl.create(:member_org) }
  let(:user) { org.users.first }
  let(:job) { FactoryGirl.build(:my_job, organization: org) }
  let(:org_admin) { org.users.admins.first }

  include_context 'job methods'
end

shared_context 'transferred job' do
  let(:the_agr_factory) { defined?(agr_factory) ? agr_factory : :subcon_agreement }
  unless example.metadata[:skip_basic_job]
    include_context 'basic job testing'
  end
  let(:subcon_agr) { FactoryGirl.build(the_agr_factory, organization: job.organization) }
  let(:subcon) {
    s      = subcon_agr.counterparty
    s.name = "subcon-#{s.name}".squish
    s.save!
    s
  }
  let(:subcon_admin) do
    subcon.users.first
  end
  let(:subcon_job) { TransferredServiceCall.find_by_organization_id_and_ref_id(subcon.id, job.ref_id) }


end

shared_context 'brokered job' do
  include_context 'transferred job'
  let(:broker_prov_agr) { FactoryGirl.build(:subcon_agreement, organization: job.organization) }
  let(:broker_subcon_agr) { FactoryGirl.build(:subcon_agreement, organization: broker) }
  let(:bom_reimb) { defined?(bom_reimbursement) ? bom_reimbursement : 'true' }
  let(:broker) {
    b      = broker_prov_agr.counterparty
    b.name = "broker-#{b.name}"
    b.save!
    b
  }
  let(:subcon) {
    s      = broker_subcon_agr.counterparty
    s.name = "subcon-#{s.name}"
    s.save!
    s
  }
  let(:broker_admin) do
    broker.users.first
  end

  let(:subcon_admin) do
    subcon.users.first
  end

  let(:subcon_job) { TransferredServiceCall.find_by_organization_id_and_ref_id(subcon.id, job.ref_id) }
  let(:broker_job) { TransferredServiceCall.find_by_organization_id_and_ref_id(broker.id, job.ref_id) }
  let(:broker_b4_transfer_job) { TransferredServiceCall.find_by_organization_id_and_ref_id(broker.id, job.ref_id) }
  before do
    with_user(org_admin) do
      transfer_the_job job: job, subcon: broker, agreement: broker_prov_agr, bom_reimbursement: bom_reimb
    end
    with_user(broker_admin) do
      accept_the_job broker_b4_transfer_job
      transfer_the_job job: broker_b4_transfer_job, subcon: subcon, agreement: broker_subcon_agr, bom_reimbursement: bom_reimb
    end
  end


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

def transfer_the_job(options = {})
  the_agr           = options[:agreement] || subcon_agr
  the_job           = options[:job] || job
  the_subcon        = options[:subcon] || subcon
  bom_reimbursement = options[:bom_reimbursement] || 'true'

  the_agr.save!
  the_job.save!
  the_job.update_attributes(subcontractor:    the_subcon.becomes(Subcontractor),
                            properties:       { 'subcon_fee' => '100', 'bom_reimbursement' => bom_reimbursement },
                            subcon_agreement: the_agr,
                            status_event:     'transfer')
end

def mark_as_settled_subcon(ticket, options = {})
  the_payment_type = options[:payment_type] || 'cash'

  ticket.update_attributes(subcon_payment:             the_payment_type,
                           subcontractor_status_event: 'settle')
end

def confirm_settled_subcon(ticket)
  ticket.confirm_settled_subcon!
end

def mark_as_settled_prov(ticket, options = {})
  the_payment_type = options[:payment_type] || 'cash'

  ticket.update_attributes(provider_payment:      the_payment_type,
                           provider_status_event: 'settle')
end

def confirm_settled_prov(ticket)
  ticket.confirm_settled_provider!
end

def reject_the_job(ticket)
  ticket.reject!
end

shared_context 'when canceling the job' do
  before do
    job_to_cancel.update_attributes(status_event: 'cancel') unless example.metadata[:skip_cancel]
  end

  it 'should allow to cancel the job', skip_cancel: true do
    expect(job_to_cancel.status_events).to include(:cancel)
  end
end
