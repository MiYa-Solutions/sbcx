require 'spec_helper'

describe 'Provider Transferred Job To A Member Lifecycle' do
  include_context 'transferred job'

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

    describe 'after subcon accepts the job' do
      before do
        accept_the_job subcon_job
      end

      it 'status should be :transferred' do
        expect(job.status_name).to eq :transferred
      end

    end

  end


end