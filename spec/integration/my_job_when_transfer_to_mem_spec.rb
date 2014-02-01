require 'spec_helper'

describe 'My Job When Transferred To a Member' do

  include_context 'transferred job'
  before do
    transfer_the_job
  end

  it 'a job for the subcon should be created' do
    expect(subcon_job).to be_instance_of(TransferredServiceCall)
  end

  it 'the job status should be transferred' do
    expect(job).to be_transferred
  end

  it 'the subcon job status should be new' do
    expect(subcon_job).to be_new
  end

  it 'job work status should be pending' do
    expect(job).to be_work_pending
  end

  it 'subcon job work status should be pending' do
    expect(subcon_job).to be_work_pending
  end

  it 'job payment status should be pending' do
    expect(job).to be_payment_pending
  end

  it 'subcon job payment status should be pending' do
    expect(subcon_job).to be_payment_pending
  end

  it 'job available status events should be cancel' do
    job.status_events.should =~ [:cancel, :cancel_transfer]
  end

  it 'subcon job available status events should be accept reject and cancel' do
    subcon_job.status_events.should =~ [:accept, :reject, :cancel]
  end

  it 'a subcon user should not be permitted to cancel job before accept/reject' do
    expect(event_permitted_for_job?('status', 'cancel', subcon_admin, subcon_job)).to be_false
  end

  it 'job should have accept and reject as available work events' do
    expect(job.work_status_events).to eq [:accept, :reject]
  end

  it 'accept and reject are not permitted events for job when submitted by a user' do
    expect(event_permitted_for_job?('work_status', 'accept', org_admin, job)).to be_false
    expect(event_permitted_for_job?('work_status', 'reject', org_admin, job)).to be_false
  end

  it 'subcon job should not have available work events' do
    expect(subcon_job.work_status_events).to eq [:start]
  end

  it 'subcon job should not be permitted to start the job' do
    expect(event_permitted_for_job?('work_status', 'start', subcon_admin, subcon_job)).to be_false
  end

  it 'the provider should be allowed to collect a payment' do
    expect(job.billing_status_events).to eq [:collect]
  end

  it 'there should be no available payment events for the subcon job' do
    expect(subcon_job.billing_status_events).to be_empty
  end

  it 'job subcon status should be pending' do
    expect(job.subcontractor_status_name).to eq :pending
  end

  it 'the job should have no available subcon events' do
    expect(job.subcontractor_status_events).to eq []
  end

  it 'subcon_job prov status should be pending' do
    expect(subcon_job.provider_status_name).to eq :pending
  end

  it 'subcon_job should have no available provider events' do
    expect(subcon_job.provider_status_events).to eq []
  end


  context 'when prov cancels' do
    include_context 'when the provider cancels the job'
    it_should_behave_like 'provider job is canceled'
    it_should_behave_like 'subcon job is canceled'
  end

  context 'when the subcon cancels' do
    include_context 'when the subcon cancels the job'
    it_should_behave_like 'provider job is canceled'
    it_should_behave_like 'subcon job is canceled'
  end

  context 'when subcon accepts the job' do

    before do
      subcon_job.update_attributes(status_event: 'accept')
      job.reload
    end

    it 'the job status should be transferred' do
      expect(job).to be_transferred
    end

    it 'the subcon job status should be accepted' do
      expect(subcon_job).to be_accepted
    end

    it 'job work status should be accepted' do
      expect(job.reload).to be_work_accepted
    end

    it 'subcon job work status should be pending' do
      expect(subcon_job).to be_work_pending
    end

    it 'job payment status should be pending' do
      expect(job).to be_payment_pending
    end

    it 'subcon job payment status should be pending' do
      expect(subcon_job).to be_payment_pending
    end

    it 'job available status events should be cancel abd cancel_transfer' do
      job.status_events.should =~ [:cancel, :cancel_transfer]
    end

    it 'subcon job available status events should be cancel and transfer' do
      subcon_job.status_events.should =~ [:cancel, :transfer]
    end

    it 'job available work events are start, but start is not permitted for a user' do
      expect(job.reload.work_status_events).to eq [:start]
      expect(event_permitted_for_job?('work_status', 'start', org_admin, job)).to be_false
    end

    it 'subcon job should have start as the available work event' do
      expect(subcon_job.work_status_events).to eq [:start]
      expect(event_permitted_for_job?('work_status', 'start', subcon_admin, subcon_job)).to be_true
    end

    it 'both the provider and the subcontractor should be allowed to collect a payment' do
      job.billing_status_events.should =~ [:collect, :subcon_collected]
    end

    it 'there should be no available payment events for the subcon job' do
      expect(subcon_job.billing_status_events).to be_empty
    end

    it 'job subcon status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'the job should have no available subcon events' do
      expect(job.subcontractor_status_events).to eq []
    end

    it 'subcon_job prov status should be pending' do
      expect(subcon_job.provider_status_name).to eq :pending
    end

    it 'subcon_job should have no available provider events' do
      expect(subcon_job.provider_status_events).to eq []
    end


    context 'when the subcon start the job' do

      before do
        subcon_job.update_attributes(work_status_event: 'start')
      end

      it 'the job status should be transferred' do
        expect(job.reload).to be_transferred
      end

      it 'the subcon job status should be accepted' do
        expect(subcon_job).to be_accepted
      end

      it 'job work status should be in progress' do
        expect(job.reload).to be_work_in_progress
      end

      it 'subcon job work status should be in progress' do
        expect(subcon_job).to be_work_in_progress
      end

      it 'job payment status should be pending' do
        expect(job).to be_payment_pending
      end

      it 'subcon job payment status should be pending' do
        expect(subcon_job).to be_payment_pending
      end

      it 'job available status events should be cancel abd cancel_transfer' do
        job.status_events.should =~ [:cancel, :cancel_transfer]
      end

      it 'subcon job available status events should be cancel' do
        subcon_job.status_events.should =~ [:cancel]
      end

      it 'job available work events are complete, but complete is not permitted for a user' do
        expect(job.reload.work_status_events).to eq [:complete]
        expect(event_permitted_for_job?('work_status', 'complete', org_admin, job)).to be_false
      end

      it 'subcon job should have complete as the available work event' do
        expect(subcon_job.work_status_events).to eq [:complete]
        expect(event_permitted_for_job?('work_status', 'complete', subcon_admin, subcon_job)).to be_true
      end

      it 'the provider should be allowed to collect a payment' do
        job.billing_status_events.should =~ [:collect, :subcon_collected]
      end

      it 'there should be no available payment events for the subcon job' do
        expect(subcon_job.billing_status_events).to be_empty
      end

      it 'job subcon status should be pending' do
        expect(job.subcontractor_status_name).to eq :pending
      end

      it 'the job should have no available subcon events' do
        expect(job.subcontractor_status_events).to eq []
      end

      it 'subcon_job prov status should be pending' do
        expect(subcon_job.provider_status_name).to eq :pending
      end

      it 'subcon_job should have no available provider events' do
        expect(subcon_job.provider_status_events).to eq []
      end


      context 'when subcon completes the job' do
        before do
          add_bom_to_job subcon_job
          subcon_job.update_attributes(work_status_event: 'complete')
        end

        it 'the job status should be transferred' do
          expect(job.reload).to be_transferred
        end

        it 'the subcon job status should be accepted' do
          expect(subcon_job).to be_accepted
        end

        it 'job work status should be in progress' do
          expect(job.reload).to be_work_done
        end

        it 'subcon job work status should be done' do
          expect(subcon_job).to be_work_done
        end

        it 'job payment status should be pending' do
          expect(job).to be_payment_pending
        end

        it 'subcon job payment status should be pending' do
          expect(subcon_job).to be_payment_pending
        end

        it 'job available status events should be cancel abd cancel_transfer' do
          job.reload.status_events.should =~ [:cancel]
        end

        it 'subcon job available status events should be cancel' do
          subcon_job.status_events.should =~ [:cancel]
        end

        it 'there are no available work status events for job' do
          expect(job.reload.work_status_events).to be_empty
        end

        it 'there are no available work status events for subcon job' do
          expect(subcon_job.work_status_events).to be_empty
        end

        it 'job available payment events are invoice and invoiced by subcon, but invoice by subcon is not permitted for a user' do
          expect(job.reload.billing_status_events).to eq [:invoice, :subcon_invoiced, :collect, :subcon_collected]
          expect(event_permitted_for_job?('billing_status', 'invoice', org_admin, job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'subcon_invoiced', org_admin, job)).to be_false
        end

        it 'subcon job should have invoice and provider invoiced as the available payment events, but provider invoiced is not permitted' do
          expect(subcon_job.billing_status_events).to eq [:invoice, :provider_invoiced]
          expect(event_permitted_for_job?('billing_status', 'invoice', subcon_admin, subcon_job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'provider_invoiced', subcon_admin, subcon_job)).to be_false
        end

        it 'job subcon status should be pending' do
          expect(job.reload.subcontractor_status_name).to eq :pending
        end

        it 'there should be no available events for the subcontractor status ' do
          expect(job.reload.subcontractor_status_events).to eq []
          #expect(job.reload.subcontractor_status_events).to eq [:settle, :subcon_marked_as_settled]
          #expect(event_permitted_for_job?('subcontractor_status', 'settle', subcon_admin, subcon_job)).to be_true
          #expect(event_permitted_for_job?('subcontractor_status', 'subcon_marked_as_settled', subcon_admin, subcon_job)).to be_false
          #
        end

        it 'subcon_job prov status should be pending' do
          expect(subcon_job.provider_status_name).to eq :pending
        end

        it 'subcon_job should have no available provider events' do
          expect(subcon_job.provider_status_events).to eq []
        end


        context 'when subcon invoices' do

          before do
            subcon_job.update_attributes(billing_status_event: 'invoice')
          end

          it 'the job status should be transferred' do
            expect(job.reload).to be_transferred
          end

          it 'the subcon job status should be accepted' do
            expect(subcon_job).to be_accepted
          end

          it 'job work status should be completed' do
            expect(job.reload).to be_work_done
          end

          it 'subcon job work status should be completed' do
            expect(subcon_job).to be_work_done
          end

          it 'job payment status should be invoiced by subcon' do
            expect(job.reload).to be_payment_invoiced_by_subcon
          end

          it 'subcon job payment status should be invoiced' do
            expect(subcon_job).to be_payment_invoiced
          end

          it 'job available status events should be cancel' do
            job.reload.status_events.should =~ [:cancel]
          end

          it 'subcon job available status events should be cancel' do
            subcon_job.status_events.should =~ [:cancel]
          end

          it 'there are no available work status events for job' do
            expect(job.reload.work_status_events).to be_empty
          end

          it 'there are no available work status events for subcon job' do
            expect(subcon_job.work_status_events).to be_empty
          end

          it 'job available payment events are collect and collected by subcon, but collected by subcon is not permitted for a user' do
            expect(job.reload.billing_status_events).to eq [:overdue, :collect, :subcon_collected]
            expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'subcon_collected', org_admin, job)).to be_false
          end

          it 'subcon job should have collect and provider collected as the available payment events, but provider collected is not permitted' do
            expect(subcon_job.billing_status_events).to eq [:provider_collected, :collect]
            expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
          end

          context 'when prov cancels' do
            include_context 'when the provider cancels the job'
            it_should_behave_like 'provider job is canceled'
            it_should_behave_like 'subcon job is canceled'
          end

          context 'when the subcon cancels' do
            include_context 'when the subcon cancels the job'
            it_should_behave_like 'provider job is canceled'
            it_should_behave_like 'subcon job is canceled'
          end


        end

        context 'when prov cancels' do
          include_context 'when the provider cancels the job'
          it_should_behave_like 'provider job is canceled'
          it_should_behave_like 'subcon job is canceled'
        end

        context 'when the subcon cancels' do
          include_context 'when the subcon cancels the job'
          it_should_behave_like 'provider job is canceled'
          it_should_behave_like 'subcon job is canceled'
        end


      end

      context 'when prov cancels' do
        include_context 'when the provider cancels the job'
        it_should_behave_like 'provider job is canceled'
        it_should_behave_like 'subcon job is canceled'
      end

      context 'when the subcon cancels' do
        include_context 'when the subcon cancels the job'
        it_should_behave_like 'provider job is canceled'
        it_should_behave_like 'subcon job is canceled'
      end

    end

    context 'when prov cancels' do
      include_context 'when the provider cancels the job'
      it_should_behave_like 'provider job is canceled'
      it_should_behave_like 'subcon job is canceled'
    end

    context 'when the subcon cancels' do
      include_context 'when the subcon cancels the job'
      it_should_behave_like 'provider job is canceled'
      it_should_behave_like 'subcon job is canceled'
    end

  end

  context 'when subcon rejects the job' do
    pending
  end

end