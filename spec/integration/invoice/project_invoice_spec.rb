require 'spec_helper'

describe 'Project Invoice' do

  include_context 'basic job testing'

  let(:project) { FactoryGirl.create(:project_jobs_and_customer) }
  let(:invoice) { project.invoices.create(account:      project.customer.account,
                                          organization: project.organization) }
  let(:job) { project.tickets.first }
  let(:job2) { project.tickets.last }

  before do
    add_bom_to_job job, cost: 10, price: 100, quantity: 1
    project.tickets.reload
    add_bom_to_job job2, cost: 10, price: 100, quantity: 1
  end

  it 'project should be valid' do
    expect(project).to be_valid
  end

  it 'invoice should not be valid - no blank invoice' do
    expect(invoice).to_not be_valid
  end


  describe 'invoice with a mix of completed and none completed jobs' do
    before do
      start_the_job job
      complete_the_work job
    end

    it 'invoice should be valid' do
      expect(invoice).to be_valid
    end


    it 'invoice should have the correct total' do
      expect(invoice.total).to eq Money.new(10000)
    end

    context 'with advanced payment and an invoice created for the active job' do
      before do
        job2.invoices.create!(account:            job2.customer.account,
                              organization:       job2.organization,
                              adv_payment_amount: '50',
                              adv_payment_desc:   'Adv Payment')
        project.reload.tickets.reload
      end

      it 'invoice should have the correct total' do
        expect(invoice.total).to eq Money.new(15000)
      end
    end
  end
end