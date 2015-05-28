require 'spec_helper'

describe 'When settling with a member subcon' do

  include_context 'transferred job'

  before do
    transfer_the_job
  end

  context 'before the job is done' do
    it 'should allow settlement between the parties' do
      expect(job.subcontractor_status_events).to include :settle
      expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
    end

    context 'when the provider pays the subcon in advance' do
      before do
        settle_with_subcon job, amount: 10, type: 'cheque'
      end

      it 'should change the subcontractor status to claim_as_p_settled' do
        expect(job.subcontractor_status_name).to eq :claim_p_settled
      end

      context 'when the subcon confirms the settlement entry' do
        before do
          subcon_job.entries.order('id asc').last.confirm!
        end

        it 'should change he subcon status to partially_settled' do
          expect(job.reload.subcontractor_status_name).to eq :partially_settled
        end

        context 'when paying the subcon again' do
          before do
            settle_with_subcon job, amount: 10, type: 'cheque'
          end

          it 'should change the subcontractor status to claim_p_settled' do
            expect(job.reload.subcontractor_status_name).to eq :claim_p_settled
          end

          it 'the balance with the subcon should be 20'

          context 'when the subcon confirms all payments' do
            before do
              subcon_job.entries.collect(&:confirm!)
            end

            it 'subcon status should be partially collected'
          end

          context 'when the subcon confirms the first payment' do
            before do
              subcon_job.entries.order('id asc').first.confirm!
            end

            it 'subcon status should remain claim_p_settled'

            context 'when subcon disputes the second payment' do
              let(:disputed_payment) {subcon_job.entries.order('id asc').last}
              before do
                disputed_payment.dispute!
              end

              it 'subcon status should be disputed'
              it 'disputed_payment should have confirm as a possible event'

              context 'when the subcon confirms the disputed payment' do
                before do
                  disputed_payment.confirm!
                end

                it 'subcon status should change to partially_settled'
              end
            end
          end

        end
      end
    end
  end

end