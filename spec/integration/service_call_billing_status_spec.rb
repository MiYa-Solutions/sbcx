require 'spec_helper'

describe 'Job Billing' do


  context 'for my none transferred job' do
    include_context 'basic job testing'
    before do
      with_user(user) do
        job.start_work
        add_bom_to_job job
        job.complete_work
      end
    end

    it 'job billing status should be pending' do
      expect(job).to be_payment_pending
    end

    it 'job work status should be in_progress' do
      expect(job).to be_work_done
    end

    context 'when invoiced' do
      before do
        with_user(user) do
          job.update_attributes(billing_status_event: 'invoice')
        end
      end

      it 'billing status should be set to invoiced' do
        expect(job).to be_payment_invoiced
      end

      context 'when paid' do
        before do
          with_user(user) do
            job.update_attributes(payment_type:         'cheque',
                                  payment_amount:       '10000',
                                  billing_status_event: 'paid')

          end
        end

        it 'billing status should be set to paid' do
          expect(job.billing_status_name).to eq :paid
        end

        context 'when payment cleared' do
          before do
            with_user(user) do
              job.update_attributes(billing_status_event: 'clear')
            end
          end

          it 'should have a billing status of cleared' do
            expect(job).to be_payment_cleared
          end
        end

        context 'when payment is rejected' do
          before do
            with_user(user) do
              job.update_attributes(billing_status_event: 'reject')
            end
          end

          it 'should have a billing status of cleared' do
            expect(job).to be_payment_rejected
          end

        end


      end

    end
  end

  context 'for transferred job' do
    include_context 'transferred job'

    before do
      with_user(user) do
        job.properties = (job.properties || {}).merge('subcon_fee' => '100', 'bom_reimbursement' => 'false')
        transfer_the_job
      end
      with_user(subcon_admin) do
        subcon_job.accept!
        subcon_job.start_work!
        add_bom_to_job subcon_job
        subcon_job.complete_work!
      end
    end


    it 'job should be transferred' do
      expect(job).to be_transferred
      expect(subcon_job).to_not be_nil
    end

    it 'subcon job work should be completed' do
      expect(subcon_job).to be_work_done
      expect(job.reload).to be_work_done
    end

    context 'when invoiced by subcon' do
      before do
        with_user(subcon_admin) do
          subcon_job.update_attributes(billing_status_event: 'invoice')
        end
      end

      it 'should have billing status of invoiced' do
        expect(job.reload).to be_payment_invoiced_by_subcon
        expect(subcon_job).to be_payment_invoiced
      end

      context 'when cheque collected' do
        before do
          with_user(subcon_admin) do
            subcon_job.update_attributes(payment_type:         'cheque',
                                         payment_amount:       '10000',
                                         collector:            subcon,
                                         billing_status_event: 'collect')

          end
        end

        it 'should have billing status of collected' do
          expect(job.reload.billing_status_name).to eq :collected_by_subcon
          expect(subcon_job.billing_status_name).to eq :payment_collected
        end

        context 'when deposited to prov' do
          before do
            with_user(subcon_admin) do
              subcon_job.update_attributes(billing_status_event: 'deposit_to_prov')
            end
          end

          it 'should have billing status of collected' do
            expect(job.reload).to be_payment_subcon_claim_deposited
            expect(subcon_job).to be_payment_deposited_to_prov
          end

          context 'when deposit is confirmed' do
            before do
              with_user(user) do
                job.reload.update_attributes(billing_status_event: 'confirm_deposit')
              end
            end

            it 'should have billing status of paid' do
              expect(job).to be_payment_paid
              expect(subcon_job.reload).to be_payment_deposited
            end


            context 'when payment is rejected' do
              before do
                with_user(user) do
                  job.update_attributes(billing_status_event: 'reject') unless example.metadata[:skip_reject]
                end
              end

              it 'should have billing status of rejected' do
                expect(job).to be_payment_rejected
                expect(subcon_job.reload).to be_payment_deposited
              end

              it 'should have create a ScPaymentRejectedEvent', skip_reject: true do
                expect { job.update_attributes(billing_status_event: 'reject') }.to change { ScPaymentRejectedEvent.count }.by(1)
                expect(ScPaymentRejectedEvent.last.service_call).to eq(job)
              end

            end
          end

        end


      end
    end

  end

end