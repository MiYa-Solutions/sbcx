require 'spec_helper'

describe 'Billing when only the subcon collects' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
  end

  it 'should  allow a collection for the subcon and provider' do
    expect(subcon_job.billing_status_events).to eq [:collect]
    expect(job.reload.billing_status_events).to include(:collect)
  end

  describe 'when collecting both before and after job is done'

  describe 'when collecting only before job done'

  describe 'when collecting only after job done'



end