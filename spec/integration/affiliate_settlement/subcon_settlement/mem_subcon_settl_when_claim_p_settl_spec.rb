require 'spec_helper'

describe 'Member Subcon Settlement: When claim_p_settled' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    job.reload
    settle_with_subcon job, amount: 10, type: 'cheque'
  end

  let(:subcon_entry1) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }

  it 'subcon status should be claim_p_settled' do
    expect(job.reload.subcontractor_status_name).to eq :claim_p_settled
  end

  context 'when the subcon confirms the settlement entry' do
    before do
      subcon_entry1.confirm!
    end

    it 'should change he subcon status to partially_settled' do
      expect(job.reload.subcontractor_status_name).to eq :partially_settled
    end

  end

  context 'when the subcon disputes the settlement entry' do
    before do
      subcon_entry1.dispute!
      job.reload
    end

    it 'should change the subcon status to disputed' do
      expect(job.subcontractor_status_name).to eq :disputed
    end
  end

  context 'when competing the job' do
    before do
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
      complete_the_work subcon_job
      job.reload
    end

    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-10000)
    end

    context 'when settling for the remaining amount' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
      end

      it 'should change the status as claim_settled' do
        expect(job.subcontractor_status_name).to eq :claim_settled
      end

    end
  end

  context 'before completing the work' do
    context 'when the provider pays the subcon the reminder' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
        job.reload
      end

      it 'subcon status should remain claim_p_settled' do
        expect(job.subcontractor_status_name).to eq :claim_p_settled
      end

      context 'when competing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          subcon_job.reload
          complete_the_work subcon_job
          job.reload
        end

        it 'subcon status should change to claim_settled' do
          expect(job.subcontractor_status_name).to eq :claim_settled
        end

      end


    end
  end

end