require 'spec_helper'

describe 'Cancel Transfer To Local' do

  include_context 'job transferred to local subcon'

  before do
    transfer_the_job
    accept_on_behalf_of_subcon(job)
  end


  describe 'before work starts' do
    before do
      cancel_the_transfer job
      job.reload
    end

    it 'status should be be transferred' do
      expect(job.status_name).to eq :new
    end

    it 'sucon status should be :na' do
      expect(job.subcontractor_status_name).to eq :na
    end
  end
end