require 'spec_helper'

describe 'Invoice Integration Tests' do

  include_context 'basic job testing'

  let(:invoice) { Invoice.create(organization: job.organization,
                                 invoiceable: job,
                                 account: job.customer.account,
                                 adv_payment_amount: 100,
                                 adv_payment_desc: 'test',
                                 email_customer: '') }

  before do
    add_bom_to_job job, cost: 10, price: 100, quantity: 1
    add_bom_to_job job, cost: 10, price: 100, quantity: 1
  end

  it 'invoice should be valid' do
    expect(invoice).to be_valid
  end

  context 'when the job is still active' do
    it 'should have the right total' do
      expect(invoice.total).to eq Money.new(10000)
    end

    it 'invoice total should equal customer balance' do
      expect(invoice.total).to eq job.customer_balance
    end

    context 'when collecting payment' do
      before do
        collect_a_payment job, amount: 50
        job.reload
      end

      it 'should have the right total' do
        expect(invoice.total).to eq Money.new(5000)
      end

      it 'invoice total should equal customer balance' do
        expect(invoice.total).to eq job.customer_balance
      end

    end

  end

  context 'when the job is complete' do

    before do
      start_the_job job
      complete_the_work job
    end

    it 'should have the right total' do
      expect(invoice.total).to eq Money.new(20000)
    end

    it 'invoice total should equal customer balance' do
      expect(invoice.total).to eq job.customer_balance
    end

    context 'when collecting payment' do
      before do
        collect_a_payment job, amount: 50
        job.reload
      end

      it 'should have the right total' do
        expect(invoice.total).to eq Money.new(15000)
      end

      it 'invoice total should equal customer balance' do
        expect(invoice.total).to eq job.customer_balance
      end

    end

  end
end