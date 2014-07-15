require 'spec_helper'

describe 'Subcon Collection Status Before Job Accepted' do

  include_context 'transferred job'

  before do
    transfer_the_job
  end

  it 'should allow a collection for the provider' do
    expect(job.billing_status_events).to include(:collect)
  end

end