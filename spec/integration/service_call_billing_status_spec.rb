require 'spec_helper'

describe 'Job Billing' do


  context 'for none transferred job' do
    include_context 'basic job testing'
    before do
      with_user(user) do
        org.save!
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
                                  billing_status_event: 'paid')

          end
        end

        it 'billing status should be set to invoiced' do
          expect(job).to be_payment_paid
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
      transfer_the_job
    end


    it 'job should be transferred' do
      expect(job).to be_transferred
    end

  end

end