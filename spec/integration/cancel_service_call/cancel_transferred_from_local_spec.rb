require 'spec_helper'

describe 'Cancel Job Transferred From Local' do

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end

  before do
    provider.save!
    accept_the_job job
  end

  it 'should have the cancel event available' do

  end

  it 'subcon collection events should be :cancel' do
    expect(job.status_events.sort).to eq [:cancel]
  end


  context 'when canceling the job before starting it' do
    before do
      cancel_the_job job
    end

    it 'status should be :canceled' do
      expect(job.status_name).to eq :canceled
    end

  end

  describe 'when canceling after starting the job and adding a bom' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: org
      cancel_the_job job
    end

    it 'status should be :canceled' do
      expect(job.status_name).to eq :canceled
    end

  end

end