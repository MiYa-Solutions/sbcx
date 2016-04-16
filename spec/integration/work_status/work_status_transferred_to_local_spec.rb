require 'spec_helper'

describe 'Work Status When transferred to a local subcon' do

  include_context 'job transferred to local subcon'
  before do
    transfer_the_job
  end

  it 'the two work events should be accept and reject' do
    expect(job.work_status_events.sort).to eq [:accept, :reject]
  end

  context 'when accepting on behalf of subcon' do
    before do
      accept_on_behalf_of_subcon job
    end

    it 'the two work events should be start and reset but reset is not allowed for user' do
      expect(job.work_status_events.sort).to eq [:cancel, :reset, :start]
      expect(event_permitted_for_job?(:work_status, 'reset', org_admin, job)).to eq false
      expect(event_permitted_for_job?(:work_status, 'cancel', org_admin, job)).to eq false
      expect(event_permitted_for_job?(:work_status, 'start', org_admin, job)).to eq true
    end

    context 'when starting on behalf of the subcon' do
      before do
        start_the_job job
      end

      it 'should have work status of in_progress' do
        expect(job.work_status_name).to eq :in_progress
      end

      it 'the two work events should be start and reset but reset is not allowed for user' do
        expect(job.work_status_events.sort).to eq [:cancel, :complete, :reset]
        expect(event_permitted_for_job?(:work_status, 'reset', org_admin, job)).to eq false
        expect(event_permitted_for_job?(:work_status, 'cancel', org_admin, job)).to eq false
        expect(event_permitted_for_job?(:work_status, 'complete', org_admin, job)).to eq true
      end

    end

  end

end