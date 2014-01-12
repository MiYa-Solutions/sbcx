require 'spec_helper'

describe 'Transferred Service Call Integration Spec' do

  context 'when transferred from a local provider' do
    include_context 'job transferred from a local provider'

    it 'should be instance of TransferredServiceCall' do
      expect(job).to be_instance_of(TransferredServiceCall)
    end

    it 'should be valid' do
      expect(job).to be_valid
    end

    it 'status should be new' do
      expect(job.status_name).to eq :new
    end

    it 'the available status events should be: cancel, accept and reject' do
      expect(job.status_events).to eq [:accept, :reject, :cancel]
      expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
      expect(event_permitted_for_job?('status', 'accept', org_admin, job)).to be_true
      expect(event_permitted_for_job?('status', 'reject', org_admin, job)).to be_true
    end

    it 'provider status should be pending' do
      expect(job.provider_status_name).to eq :pending
    end

    it 'there should be no available provider events' do
      expect(job.provider_status_events).to eq []
    end

    it 'subcon status should be na' do
      expect(job.subcontractor_status_name).to eq :na
    end

    it 'payment status should be pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'there should be no available payment status events' do
      expect(job.billing_status_events).to eq []
    end

    it 'work status should be pending' do
      expect(job.work_status_name).to eq :pending
    end

    it 'start should be available as a work status event, but it should not be permitted for a user' do
      expect(job.work_status_events).to eq [:start]
      expect(event_permitted_for_job?('work_status', 'start', org_admin, job)).to be_false
    end

    context 'when accepted' do

      before do
        job.update_attributes(status_event: 'accept')
      end

      it 'status should be new' do
        expect(job.status_name).to eq :accepted
      end

      it 'the available status events should be: cancel, accept and reject' do
        expect(job.status_events).to eq [:transfer, :cancel]
        expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
        expect(event_permitted_for_job?('status', 'transfer', org_admin, job)).to be_true
      end

      it 'provider status should be pending' do
        expect(job.provider_status_name).to eq :pending
      end

      it 'there should be no available provider events' do
        expect(job.provider_status_events).to eq []
      end

      it 'subcon status should be na' do
        expect(job.subcontractor_status_name).to eq :na
      end

      it 'payment status should be pending' do
        expect(job.billing_status_name).to eq :pending
      end

      it 'there should be no available payment status events' do
        expect(job.billing_status_events).to eq []
      end

      it 'work status should be pending' do
        expect(job.work_status_name).to eq :pending
      end

      it 'start should be available as the only work status event' do
        expect(job.work_status_events).to eq [:start]
        expect(event_permitted_for_job?('work_status', 'start', org_admin, job)).to be_true
      end

    end

    context 'when rejected'

    context 'when canceled' do
      include_context 'when canceling the job' do
        let(:job_to_cancel) { job }
      end
      it_behaves_like 'provider job is canceled'
    end

  end
end