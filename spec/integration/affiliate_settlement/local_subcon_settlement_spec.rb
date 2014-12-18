require 'spec_helper'

describe 'Local Subcon Settlement' do
  include_context 'job transferred to local subcon'

  context 'when pending' do
    before do
      user.save!
      transfer_the_job
      accept_on_behalf_of_subcon job
      start_the_job job
      add_bom_to_job job, buyer: job.subcontractor, price: 100, quantity: 1
      complete_the_work job
    end

    it 'subcon status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end
    it 'subcon status events should be settle' do
      expect(job.subcontractor_status_events).to include :settle
    end

    it 'subcon account balance for prov should be -110.00 (-subcon fee -  bom reimbursement)' do
      expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-10000 - 1000)
    end


    context 'when settling' do

      context 'when settling with cash full payment' do
        before do
          settle_with_subcon job, amount: '110', type: 'cash'
        end

        it 'subcon status should be settled' do
          expect(job.subcontractor_status_name).to eq :settled
        end

        it 'subcon account balance for prov should be 0.00 ' do
          expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        context 'when payment is confirmed' do
          let(:subcon_payment) { job.subcon_entries.last }
          before do
            subcon_payment.confirmed!
          end

          it 'entry status should be confirmed' do
            expect(subcon_payment.status_name).to eq :confirmed
          end

          context 'when depositing the on behalf of the subcon' do
            before do
              subcon_payment.deposit!
            end

            it 'entry status should be confirmed' do
              expect(subcon_payment.status_name).to eq :cleared
            end

            it 'subcon status should be set to cleared' do
              expect(job.reload.subcontractor_status_name).to eq :cleared
            end


          end
        end

      end

      context 'when settling with cash partial payment' do
        before do
          settle_with_subcon job, amount: '10', type: 'cash'
        end

        it 'subcon status should be settled' do
          expect(job.subcontractor_status_name).to eq :partially_settled
        end

        it 'subcon account balance for prov should be 0.00 ' do
          expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-10000)
        end

        context 'when payment is confirmed' do
          let(:subcon_payment) { job.subcon_entries.last }
          before do
            subcon_payment.confirmed!
          end

          it 'entry status should be confirmed' do
            expect(subcon_payment.status_name).to eq :confirmed
          end

          context 'when depositing the on behalf of the subcon' do
            before do
              subcon_payment.deposit!
            end

            it 'entry status should be confirmed' do
              expect(subcon_payment.status_name).to eq :cleared
            end

            it 'subcon status should be set to cleared' do
              expect(job.reload.subcontractor_status_name).to eq :partially_settled
            end


          end

          context 'when settling with the remaining amount' do
            before do
              settle_with_subcon job, amount: '100', type: 'cash'
            end

            it 'subcon status should be settled' do
              expect(job.subcontractor_status_name).to eq :settled
            end

            it 'subcon account balance for prov should be 0.00 ' do
              expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
            end

            context 'when deposting the payment' do
              let(:second_settlement) {job.subcon_entries.last}
              before do
                second_settlement.confirmed!
              end

              it 'entry status should be confirmed' do
                expect(second_settlement.status_name).to eq :confirmed
              end

              context 'when depositing the on behalf of the subcon' do
                before do
                  second_settlement.deposit!
                end

                it 'entry status should be cleared' do
                  expect(second_settlement.status_name).to eq :cleared
                end

                it 'subcon status should be set to settled' do
                  expect(job.reload.subcontractor_status_name).to eq :settled
                end

                context 'when depositing all the payments' do
                  before do
                    subcon_payment.deposit!
                  end

                  it 'entry status should be confirmed' do
                    expect(subcon_payment.status_name).to eq :cleared
                  end

                  it 'subcon status should be set to cleared' do
                    expect(job.reload.subcontractor_status_name).to eq :cleared

                  end

                end


              end

            end

          end
        end

      end

      context 'when settling with cheque for the full amount' do
        before do
          settle_with_subcon job, amount: '110', type: 'cheque'
        end

        it 'subcon status should be settled' do
          expect(job.subcontractor_status_name).to eq :settled
        end

        context 'when depositing the cheque' do
          before do
            job.subcon_payments.last.confirmed!
            job.subcon_payments.last.deposit!
          end

          it 'subcon status should be settled' do
            expect(job.reload.subcontractor_status_name).to eq :settled
          end

          context 'when clear the cheque' do
            before do
              job.subcon_payments.last.clear!
            end

            it 'subcon status should be settled' do
              expect(job.reload.subcontractor_status_name).to eq :cleared
            end

          end

          context 'when the cheque bounces' do
            before do
              job.subcon_payments.last.reject!
            end

            it 'subcon status should be rejected' do
              expect(job.reload.subcontractor_status_name).to eq :rejected
            end

            it 'subcon account balance for prov should be -110.00 ' do
              expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000)
            end


          end


        end

      end

    end

    context 'when subcon collects a payment' do
      before do
        collect_a_payment job, amount: 10, type: 'cash', collector: job.subcontractor
        job.reload
      end

      it 'subcon account balance for prov should be the subcon fee - the collected amount (10) - collection fee - bom reimbur' do
        expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-10000 + 1000 + 10 - 1000)
      end

      it 'should not be allowed to settle with the subcon' do
        expect(job.subcontractor_status_events).to_not include :settle
      end

      context 'when subcon deposits the payment' do
        before do
          job.collected_entries.last.deposited!
          job.reload

        end

        it 'should not be allowed to settle with the subcon' do
          expect(job.subcontractor_status_events).to_not include :settle
        end

        context 'when confirming the deposit' do
          before do
            job.deposited_entries.last.confirm!
          end

          it 'should be allowed to settle with the subcon' do
            expect(job.subcontractor_status_events).to include :settle
          end

          context 'when settling with the subcon' do

            before do
              settle_with_subcon job, amount: '109.9', type: 'cash'
              job.subcon_payments.last.confirmed!
              job.subcon_payments.last.deposit!
              job.reload
            end

            it 'subcon account balance for prov should be just the collected amount (0)' do
              expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
            end

            it 'subcon status should be cleared' do
              expect(job.subcontractor_status_name).to eq :cleared
            end

            it 'the available collectors should not include the subcon anymore' do
              expect(job.available_payment_collectors).to eq [job.organization]
            end

          end
        end
      end


    end
  end
end