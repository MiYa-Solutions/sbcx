require 'spec_helper'

describe 'Provider Transferred Job To Local Lifecycle' do
  include_context 'basic job testing'
  let(:subcon) { FactoryGirl.build(:local_org) }
  let(:subcon_agr) { FactoryGirl.build(:subcon_agreement, organization: job.organization, counterparty: subcon) }

  it 'status should be :new' do
    expect(job.status_name).to eq :new
  end

  it 'status events should be :start and :transfer' do
    expect(job.status_events.sort).to eq [:cancel, :transfer]
  end

  describe 'after transferring' do
    before do
      transfer_the_job job: job, agreement: subcon_agr, subcon: subcon
    end

    it 'status should be :transferred' do
      expect(job.status_name).to eq :transferred
    end

    describe 'after accepting the job' do
      before do
        accept_on_behalf_of_subcon job
      end

      it 'status should be :transferred' do
        expect(job.status_name).to eq :transferred
      end

    end

  end


end