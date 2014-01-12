require 'spec_helper'

describe 'Transferred Service Call Integration Spec' do

  context 'when transferred from a local provider and doing the job' do
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

      it 'status should be accepted' do
        expect(job.status_name).to eq :accepted
      end

      it 'the available status events should be: cancel and transfer' do
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

      context 'when canceled' do
        include_context 'when canceling the job' do
          let(:job_to_cancel) { job }
        end
        it_behaves_like 'provider job is canceled'
      end

      context 'when started the work' do

        before do
          job.update_attributes(work_status_event: 'start')
        end

        it 'status should be accepted' do
          expect(job.status_name).to eq :accepted
        end

        it 'the available status events should be: cancel and transfer' do
          expect(job.status_events).to eq [:cancel]
          expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
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

        it 'work status should be in progress' do
          expect(job.work_status_name).to eq :in_progress
        end

        it 'complete should be available as the only work status event' do
          expect(job.work_status_events).to eq [:complete]
          expect(event_permitted_for_job?('work_status', 'complete', org_admin, job)).to be_true
        end

        context 'when canceled' do
          include_context 'when canceling the job' do
            let(:job_to_cancel) { job }
          end
          it_behaves_like 'provider job is canceled'
        end

        context 'when completed the job' do
          before do
            add_bom_to_job job
            job.update_attributes(work_status_event: 'complete')
          end

          it 'status should be accepted' do
            expect(job.status_name).to eq :accepted
          end

          it 'the available status events should be: cancel' do
            expect(job.status_events).to eq [:cancel]
            expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
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

          it 'the available payment events should be: invoice and invoiced by prov' do
            expect(job.billing_status_events).to eq [:invoice, :provider_invoiced]
            expect(event_permitted_for_job?('billing_status', 'invoice', org_admin, job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'provider_invoiced', org_admin, job)).to be_true
          end

          it 'work status should be done' do
            expect(job.work_status_name).to eq :done
          end

          it 'there should be no available work status events' do
            expect(job.work_status_events).to eq []
          end

          context 'when canceled' do
            include_context 'when canceling the job' do
              let(:job_to_cancel) { job }
            end
            it_behaves_like 'provider job canceled after completion'
          end

          context 'when I invoice' do

            before do
              job.update_attributes(billing_status_event: 'invoice')
            end

            it 'status should be accepted' do
              expect(job.status_name).to eq :accepted
            end

            it 'the available status events should be: cancel' do
              expect(job.status_events).to eq [:cancel]
              expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
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

            it 'payment status should be invoiced' do
              expect(job.billing_status_name).to eq :invoiced
            end

            it 'the available payment events should be: invoice and invoiced by prov' do
              expect(job.billing_status_events).to eq [:provider_collected, :collect]
              expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
              expect(event_permitted_for_job?('billing_status', 'provider_collected', org_admin, job)).to be_true
            end

            it 'work status should be done' do
              expect(job.work_status_name).to eq :done
            end

            it 'there should be no available work status events' do
              expect(job.work_status_events).to eq []
            end

            context 'when canceled' do
              include_context 'when canceling the job' do
                let(:job_to_cancel) { job }
              end
              it_behaves_like 'provider job canceled after completion'
            end


          end

          context 'when provider invoices'

        end


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