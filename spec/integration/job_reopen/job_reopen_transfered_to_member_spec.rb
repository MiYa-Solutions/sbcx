require 'spec_helper'

describe 'After completing the work' do

  include_context 'transferred job'

  before do
    transfer_the_job job: job, bom_reimbursement: true
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 10, price: 100, quantity: 2, buyer: subcon
    complete_the_work subcon_job
    job.reload
    subcon_job.reload
  end

  it 'work status should be done' do
    expect(job.work_status_name).to eq :done
  end

  it 'customer balance should be 100' do
    expect(job.customer.account.reload.balance).to eq Money.new(20000)
  end

  it 'subcon balance should be 101' do
    expect(org.account_for(subcon).reload.balance).to eq Money.new(-12000)
  end

  context 'when re-opening the job' do
    it 'reopening a job should not be allowed to provider' do
      expect { reopen_the_job job }.to raise_error(StateMachine::InvalidTransition)
    end
  end

end