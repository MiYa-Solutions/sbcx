require 'spec_helper'

describe 'Subcon Collection After Customer accepts' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
  end


  it 'should  allow a collection for the subcon and provider' do
    expect(subcon_job.billing_status_events).to eq [:collect]
    expect(job.reload.billing_status_events).to include(:collect)
  end


end