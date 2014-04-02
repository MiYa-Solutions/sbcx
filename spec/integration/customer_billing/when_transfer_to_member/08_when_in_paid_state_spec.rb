require 'spec_helper'


describe 'Customer Billing When Provider Transfers To Member' do

  include_context 'transferred job'

  before do
    transfer_the_job
  end


  context 'when in paid state' do
    it 'there should be no billing events' do
      expect(job.billing_status_events.sort).to eq []
    end

  end

end