require 'spec_helper'

describe 'Invoice Active Job' do

  include_context 'basic job testing'

  before do
    add_bom_to_job job, quantity: 1, price: 100, cost: 10
  end

  describe 'create an invoice (with creating advance payment)' do
    before do
      job.customer.account.entries << AdvancePayment.new( amount: Money.new(10000), ticket: job, description: 'test')
      job.reload
      invoice job
    end

    it 'should create a successful invoice' do
      expect(job.invoices.size).to eq 1
    end

    it 'the invoice should have just one invoice item (the advance payment)' do
      expect(job.invoices.last.invoice_items.size).to eq 1
    end

    it 'customer account balance should be 100.00' do
      expect(job.customer.account.balance).to eq Money.new(10000)
      expect(job.customer_balance).to eq Money.new(10000)
    end

    context 'after completing the work' do
      before do
        start_the_job job
        add_bom_to_job job, price: 1000, cost: 100, quantity: 1
        complete_the_work job
        invoice job
      end

      it 'should create a successful invoice' do
        expect(job.invoices.size).to eq 2
      end

      it 'the invoice should have just two invoice item ( 2 boms)' do
        expect(job.invoices.last.invoice_items.size).to eq 2
      end

      it 'invoice total should be the job total' do
        expect(job.invoices.last.total).to eq job.total
      end

      context 'when collecting payment' do
        before do
          collect_a_payment job, amount: 100, type: 'cash'
          invoice job
        end

        it 'should create a successful invoice' do
          expect(job.invoices.size).to eq 3
        end

        it 'the invoice should have just three invoice item ( 2 boms + 1 payment)' do
          expect(job.invoices.last.invoice_items.size).to eq 3
        end

        it 'invoice total should be the job total - payment' do
          expect(job.invoices.last.total).to eq job.total - Money.new(10000)
        end

      end


    end

  end





end