require 'spec_helper'

describe 'Cancel Job When Transferred To a Member' do

  include_context 'transferred job'

  before do
    transfer_the_job
  end

  describe 'subcon cancels after accepting' do

    before do
      accept_the_job subcon_job
      cancel_the_job subcon_job
      job.reload
    end

    it 'subcon job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end

    it 'job work status should be :canceled' do
      expect(job.work_status_name).to eq :canceled
    end

  end


end