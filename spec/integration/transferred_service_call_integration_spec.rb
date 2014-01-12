require 'spec_helper'

describe 'Transferred Service Call Integration Spec' do

  context 'when transferred from a local provider' do
    include_context 'job transferred from a local provider'

    it 'status should be new' do
      expect(job.status_name).to eq :new
    end

    it 'should be instance of TransferredServiceCall' do
      expect(job).to be_instance_of(TransferredServiceCall)
    end

    it 'should be valid' do
      expect(job).to be_valid
    end
  end
end