require 'spec_helper'

describe 'Work Status When transferred to a local subcon' do

  include_context 'transferred job'
  before do
    transfer_the_job
  end

  it 'there should be no work events for the prov available for the user' do
    expect(job.work_status_events.sort).to eq [:accept, :reject]
    expect(event_permitted_for_job?(:work_status, 'accept', org_admin, job)).to eq false
    expect(event_permitted_for_job?(:work_status, 'reject', org_admin, job)).to eq false
  end

  it 'there should be no work events for the subcon' do
    expect(subcon_job.work_status_events.sort).to eq []
  end

  context 'when accepting on behalf of subcon' do
    before do
      accept_the_job subcon_job
      job.reload
    end

    it 'the work events should be: start' do
      expect(subcon_job.work_status_events.sort).to eq [:start]
      expect(event_permitted_for_job?(:work_status, 'start', subcon_admin, subcon_job)).to eq true
    end

    it 'the two work events should be start and cancel but both are not allowed for user' do
      expect(job.work_status_events.sort).to eq [:cancel, :reset, :start]
      expect(event_permitted_for_job?(:work_status, 'start', org_admin, job)).to eq false
      expect(event_permitted_for_job?(:work_status, 'cancel', org_admin, job)).to eq false
      expect(event_permitted_for_job?(:work_status, 'reset', org_admin, job)).to eq false
    end

  end

end