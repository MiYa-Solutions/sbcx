require 'spec_helper'

describe 'Billing when in collected state' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
  end


  context 'when collected by the subcon' do
    before do
      collect_a_payment subcon_job, type: 'cash', amount: 1000
    end

    it 'subcon balance should match provider balance' do
      expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
    end

    it 'billing status should be collected' do
      expect(job.reload.billing_status_name).to eq :collected
    end

    it 'billing events should be :deposited' do
      expect(job.reload.billing_status_events.sort).to eq [:deposited]
    end

    it 'deposit should not be allowed for user' do
      expect(event_permitted_for_job?('billing_status', 'deposited', user, job)).to be_false
    end

    it 'the corresponding payment should not allow to deposit before subcon marks as deposited' do
      expect(job.reload.payments.last.allowed_status_events).to eq []
    end


    context 'when fully deposited to provider' do
      before do
        deposit_all_entries subcon_job.collection_entries
      end

      it 'the corresponding payment should now allow to deposit clear and reject as the subcon marked collection as deposited' do
        expect(job.reload.payments.last.allowed_status_events.sort).to eq [:clear, :deposit, :reject ]
      end

    end


    pending 'when all cash and overpaid'
    pending 'when all cash and fully paid'
  end

  pending 'when collected by provider'

  pending 'when both provider and subcon collected'


end