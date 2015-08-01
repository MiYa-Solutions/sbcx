require 'spec_helper'

describe 'Member Subcon Settlement: When claim_settled' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
    complete_the_work subcon_job
    job.reload
    settle_with_subcon job, amount: 110, type: 'cheque'
    subcon_job.reload
  end

  let(:subcon_entry1) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }

  it 'provider status should be claimed_as_settled' do
    expect(subcon_job.provider_status_name).to eq :claimed_as_settled
  end

  context 'when the subcon confirms the settlement entry' do
    before do
      subcon_entry1.confirm!
    end

    it 'should change he provider status to settled' do
      expect(subcon_job.reload.provider_status_name).to eq :settled
    end

  end

  context 'when the subcon disputes the settlement entry' do
    before do
      subcon_entry1.dispute!
      subcon_job.reload
    end

    it 'should change the provider status to disputed' do
      expect(subcon_job.provider_status_name).to eq :disputed
    end
  end

end