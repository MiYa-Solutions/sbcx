require 'spec_helper'

describe '3rd Party Collection' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
  end

  context 'when in collected state' do

    context 'when subcon collected' do

      context 'with a single collection' do
        before do
          collect_full_amount subcon_job
          subcon_job.reload
          broker_job.reload
          job.reload
        end

        it 'subcon collection status should be collected' do
          expect(job.subcon_collection_status_name).to eq :collected
        end

        it 'subcon collection status should be collected' do
          expect(broker_job.subcon_collection_status_name).to eq :collected
        end

        it 'provider collection status should be collected' do
          expect(broker_job.prov_collection_status_name).to eq :collected
        end

        it 'provider collection status should be collected' do
          expect(subcon_job.prov_collection_status_name).to eq :collected
        end

        context 'when deposited' do

          context 'when subcon deposits' do
            before do
              subcon_job.collection_entries.last.deposit!
              subcon_job.reload
              broker_job.reload
              job.reload
            end

            it 'subcon collection status should be collected' do
              expect(job.subcon_collection_status_name).to eq :collected
            end

            it 'subcon collection status should be is_deposited' do
              expect(broker_job.subcon_collection_status_name).to eq :is_deposited
            end

            it 'provider collection status should be collected' do
              expect(broker_job.prov_collection_status_name).to eq :collected
            end

            it 'provider collection status should be is_deposited' do
              expect(subcon_job.prov_collection_status_name).to eq :is_deposited
            end

            it 'subcon should not be allowed to confirm the deposited payments' do
              expect(subcon_job.deposit_entries.last.allowed_status_events).to be_empty
            end

            context 'when the broker confirms the deposit' do
              before do
                broker_job.deposited_entries.last.confirm!
                broker_job.reload
              end
              it 'subcon collection status should be is_deposited' do
                expect(broker_job.subcon_collection_status_name).to eq :deposited
              end

            end

            context 'when broker deposits subcon deposit entry' do
              before do
                broker_job.collection_entries.last.deposit!
                subcon_job.reload
                broker_job.reload
                job.reload
              end
              it 'subcon collection status should be is_deposited' do
                expect(job.subcon_collection_status_name).to eq :is_deposited
              end

              it 'subcon collection status should be is_deposited' do
                expect(broker_job.subcon_collection_status_name).to eq :is_deposited
              end

              it 'provider collection status should be is_deposited' do
                expect(broker_job.prov_collection_status_name).to eq :is_deposited
              end

              it 'provider collection status should be is_deposited' do
                expect(subcon_job.prov_collection_status_name).to eq :is_deposited
              end


            end

          end
        end
      end

      context 'with a multi collection' do
        before do
          collect_a_payment subcon_job, amount: 500, type: 'cash'
          subcon_job.reload
          collect_a_payment subcon_job, amount: 500, type: 'amex_credit_card'
          subcon_job.reload
          broker_job.reload
          job.reload
        end

        it 'subcon collection status should be collected' do
          expect(job.subcon_collection_status_name).to eq :collected
        end

        it 'subcon collection status should be collected' do
          expect(broker_job.subcon_collection_status_name).to eq :collected
        end

        it 'provider collection status should be collected' do
          expect(broker_job.prov_collection_status_name).to eq :collected
        end

        it 'provider collection status should be collected' do
          expect(subcon_job.prov_collection_status_name).to eq :collected
        end

        context 'when deposited' do

          context 'when subcon deposits' do
            before do
              subcon_job.collection_entries.first.deposit!
              subcon_job.reload
              broker_job.reload
              job.reload
            end

            it 'prov job: subcon collection status should be collected' do
              expect(job.subcon_collection_status_name).to eq :collected
            end

            it 'broker job: subcon collection status should be collected (as not all was deposited)' do
              expect(broker_job.subcon_collection_status_name).to eq :collected
            end

            it 'broker_job: provider collection status should be collected' do
              expect(broker_job.prov_collection_status_name).to eq :collected
            end

            it 'subcon_job: provider collection status should be collected (as not all was deposited)' do
              expect(subcon_job.prov_collection_status_name).to eq :collected
            end

            context 'when broker deposits subcon deposit entry' do
              before do
                broker_job.collection_entries.last.deposit!
                subcon_job.reload
                broker_job.reload
                job.reload
              end
              it 'prov job: subcon collection status should be collected' do
                expect(job.subcon_collection_status_name).to eq :collected
              end

              it 'broker job: subcon collection status should be collected' do
                expect(broker_job.subcon_collection_status_name).to eq :collected
              end

              it 'broker job: provider collection status should be collected' do
                expect(broker_job.prov_collection_status_name).to eq :collected
              end

              it 'subcon job: provider collection status should be collected' do
                expect(subcon_job.prov_collection_status_name).to eq :collected
              end


            end

          end
        end
      end

    end

    context 'when broker collected' do

      before do
        collect_full_amount broker_job
        subcon_job.reload
        broker_job.reload
        job.reload
      end

      it 'subcon collection status should be collected' do
        expect(job.subcon_collection_status_name).to eq :collected
      end

      it 'subcon collection status should be pending' do
        expect(broker_job.subcon_collection_status_name).to eq :pending
      end

      it 'provider collection status should be collected' do
        expect(broker_job.prov_collection_status_name).to eq :collected
      end

      it 'provider collection status should be pending' do
        expect(subcon_job.prov_collection_status_name).to eq :pending
      end


    end

    context 'when provider collected' do
      before do
        job.reload
        collect_full_amount job
        subcon_job.reload
        broker_job.reload
        job.reload
      end

      it 'subcon collection status should be pending' do
        expect(job.subcon_collection_status_name).to eq :pending
      end

      it 'subcon collection status should be pending' do
        expect(broker_job.subcon_collection_status_name).to eq :pending
      end

      it 'provider collection status should be pending' do
        expect(broker_job.prov_collection_status_name).to eq :pending
      end

      it 'provider collection status should be pending' do
        expect(subcon_job.prov_collection_status_name).to eq :pending
      end

    end

    context 'when both broker and subcon collected' do

      context 'when broker collects a partial amount' do
        before do
          collect_a_payment broker_job, amount: 500, type: 'cash'
          subcon_job.reload
          broker_job.reload
          job.reload
        end

        it 'subcon collection status should be partially_collected' do
          expect(job.subcon_collection_status_name).to eq :partially_collected
        end

        it 'subcon collection status should be pending' do
          expect(broker_job.subcon_collection_status_name).to eq :pending
        end

        it 'provider collection status should be partially_collected' do
          expect(broker_job.prov_collection_status_name).to eq :partially_collected
        end

        it 'provider collection status should be collected' do
          expect(subcon_job.prov_collection_status_name).to eq :pending
        end

        context 'when broker deposits his collection' do
          before do
            broker_job.collection_entries.last.deposit!
            subcon_job.reload
            broker_job.reload
            job.reload
          end
          it 'prov job: subcon collection status should be is_deposited (since all that was collected is now deposited)' do
            expect(job.subcon_collection_status_name).to eq :is_deposited
          end

          it 'broker job: subcon collection status should be pending' do
            expect(broker_job.subcon_collection_status_name).to eq :pending
          end

          it 'broker job: provider collection status should be is_deposited' do
            expect(broker_job.prov_collection_status_name).to eq :is_deposited
          end

          it 'subcon job: provider collection status should be is_deposited' do
            expect(subcon_job.prov_collection_status_name).to eq :pending
          end


        end


        context 'when the subcon collects the remaining amount' do
          before do
            subcon_job.reload
            collect_a_payment subcon_job, amount: 500, type: 'cash'
            subcon_job.reload
            broker_job.reload
            job.reload
          end

          it 'subcon collection status should be collected' do
            expect(job.subcon_collection_status_name).to eq :collected
          end

          it 'subcon collection status should be collected' do
            expect(broker_job.subcon_collection_status_name).to eq :collected
          end

          it 'provider collection status should be collected' do
            expect(broker_job.prov_collection_status_name).to eq :collected
          end

          it 'provider collection status should be collected' do
            expect(subcon_job.prov_collection_status_name).to eq :collected
          end

          context 'when subcon deposits' do

            before do
              subcon_job.collection_entries.last.deposit!
              subcon_job.reload
              broker_job.reload
              job.reload
            end

            it 'subcon collection status should be collected' do
              expect(job.subcon_collection_status_name).to eq :collected
            end

            it 'subcon collection status should be is_deposited' do
              expect(broker_job.subcon_collection_status_name).to eq :is_deposited
            end

            it 'provider collection status should be collected' do
              expect(broker_job.prov_collection_status_name).to eq :collected
            end

            it 'provider collection status should be is_deposited' do
              expect(subcon_job.prov_collection_status_name).to eq :is_deposited
            end

            context 'when broker deposits subcon deposit entry' do
              before do
                broker_job.collection_entries.last.deposit!
                broker_job.collection_entries.first.deposit!
                subcon_job.reload
                broker_job.reload
                job.reload
              end

              it 'subcon collection status should be is_deposited (since  all was deposited)' do
                expect(job.subcon_collection_status_name).to eq :is_deposited
              end

              it 'subcon collection status should be is_deposited' do
                expect(broker_job.subcon_collection_status_name).to eq :is_deposited
              end

              it 'provider collection status should be is_deposited' do
                expect(broker_job.prov_collection_status_name).to eq :is_deposited
              end

              it 'provider collection status should be is_deposited' do
                expect(subcon_job.prov_collection_status_name).to eq :is_deposited
              end


            end

          end

        end
      end

    end
  end

end