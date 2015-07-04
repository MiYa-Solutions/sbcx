require 'spec_helper'

describe 'Customer Billing When Provider Transfers To Local' do

  include_context 'job transferred to local subcon'

  before do
    transfer_the_job
    accept_on_behalf_of_subcon(job)
    start_the_job job
    add_bom_to_job job, cost: '100', price: '1000', quantity: '1', buyer: job.subcontractor
  end

  describe 'collecting payment before the job is done' do

    context 'subcon collects cash' do
      before do
        collect_a_payment job, amount: '1000', type: 'cash', collector: job.subcontractor
        job.reload
      end

      it 'billing status should be partially_collected' do
        expect(job.billing_status_name).to eq :partially_collected
      end

      it 'subcon collection status should be partially_collected' do
        expect(job.subcon_collection_status_name).to eq :partially_collected
      end

      it 'the corresponding payment should not allow to deposit before subcon marks as collected' do
        expect(job.reload.payments.last.allowed_status_events).to eq []
      end


      context 'when the job is done' do
        before do
          complete_the_work job
        end

        it 'billing status should be collected' do
          expect(job.billing_status_name).to eq :collected
        end

        it 'collect should no longer be an available event' do
          expect(job.billing_status_events).to_not include :collect
        end


        context 'when depositing the collected payment at the provider' do
          before do
            job.collected_entries.last.deposited!
            job.reload
          end

          it 'billing status should be collected' do
            expect(job.reload.billing_status_name).to eq :collected
          end

          it 'subcon collection status should be is_deposited' do
            expect(job.subcon_collection_status_name).to eq :is_deposited
          end

          it 'the corresponding payment should now allow to deposit the payment as the subcon marked collection as deposited' do
            expect(job.reload.payments.last.allowed_status_events.sort).to eq [:deposit]
          end


          context 'when confirming the deposit' do
            before do
              job.deposited_entries.last.confirm!
              job.reload
            end

            it 'subcon collection status should be deposited' do
              expect(job.subcon_collection_status_name).to eq :deposited
            end


          end

          context 'when depositing the payment' do
            before do
              job.payments.last.deposit!
              job.reload
            end

            it 'billing status should be paid' do
              expect(job.billing_status_name).to eq :paid
            end

          end


        end

      end
    end

    context 'subcon collects cheque' do

      context 'when collecting the full amount' do
        before do
          collect_a_payment job, amount: '1000', type: 'cheque', collector: job.subcontractor
          job.reload
        end

        it 'billing status should be partially_collected' do
          expect(job.billing_status_name).to eq :partially_collected
        end

        it 'subcon collection status should be partially_collected' do
          expect(job.subcon_collection_status_name).to eq :partially_collected
        end

        context 'when completing the work' do
          before do
            complete_the_work job
          end

          it 'billing status should be collected' do
            expect(job.billing_status_name).to eq :collected
          end

          it 'subcon collection status should be collected' do
            expect(job.subcon_collection_status_name).to eq :collected
          end

          context 'when depositing '


        end

      end

      context 'when collecting the partial amount' do

        before do
          collect_a_payment job, amount: '100', type: 'cheque', collector: job.subcontractor
          job.reload
        end

        it 'billing status should be partially_collected' do
          expect(job.billing_status_name).to eq :partially_collected
        end

        it 'subcon collection status should be partially_collected' do
          expect(job.subcon_collection_status_name).to eq :partially_collected
        end

        context 'when completing the work' do
          before do
            complete_the_work job
          end

          context 'when depositing the payment to the prov' do
            before do
              job.collected_entries.last.deposited!
              job.reload
            end

            it 'subcon collection status should be is_deposited' do
              expect(job.subcon_collection_status_name).to eq :is_deposited
            end

            context 'when confirming the deposit' do
              before do
                job.deposited_entries.last.confirm!
                job.reload
              end
              it 'subcon collection status should be deposited' do
                expect(job.subcon_collection_status_name).to eq :deposited
              end

              context 'when subcon collects another payment' do
                before do
                  collect_a_payment job, amount: '100', type: 'cheque', collector: job.subcontractor
                  job.reload
                end

                it 'subcon collection status should be partially_collected' do
                  expect(job.subcon_collection_status_name).to eq :partially_collected
                end

                context 'when depositing the payment to the prov' do
                  before do
                    job.collected_entries.last.deposited!
                    job.reload
                  end

                  it 'subcon collection status should be is_deposited' do
                    expect(job.subcon_collection_status_name).to eq :is_deposited
                  end

                end

                context 'when the provider collects the remainder' do
                  before do
                    collect_a_payment job, amount: '800', type: 'cheque', collector: job.organization
                    job.reload
                  end

                  it 'billing events should be [:deposited, :reopen]' do
                    expect(job.billing_status_events.sort).to eq [:deposited, :reopen]
                  end

                  it 'billing status should be collected' do
                    expect(job.billing_status_name).to eq :collected
                  end


                  context 'when the cheque is deposited' do
                    before do
                      job.payments.last.deposit!
                      job.reload
                    end

                    it 'billing status should be in_process' do
                      expect(job.billing_status_name).to eq :in_process
                    end

                    context 'when the cheque bounces' do
                      before do
                        job.payments.last.reject!
                        job.reload
                      end

                      it 'billing status should be rejected' do
                        expect(job.billing_status_name).to eq :rejected
                      end

                      it 'billing events should be [:cancel, :collect, :late, :reopen]' do
                        expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reopen]
                      end

                      describe 'over payment' do
                        before do
                          collect_a_payment job, amount: '1000', type: 'cheque', collector: job.organization
                          job.reload
                        end

                        it 'billing status should be collected' do
                          expect(job.billing_status_name).to eq :collected
                        end

                        context 'when depositing the cheque' do
                          before do
                            job.payments.last.deposit!
                            job.reload
                          end

                          it 'billing status should be in_process' do
                            expect(job.billing_status_name).to eq :in_process
                          end

                          context 'when the cheque clears' do
                            before do
                              job.payments.map { |p| p.clear! if p.can_clear? }
                              job.reload
                            end

                            it 'billing status should be over_paid' do
                              expect(job.billing_status_name).to eq :over_paid
                            end

                            it 'billing events should be [:reimburse, :reopen]' do
                              expect(job.billing_status_events.sort).to eq [:reimburse, :reopen]
                            end

                            it 'expect customer account to have an extra 200' do
                              expect(job.customer.account.balance).to eq Money.new(-20000)
                            end

                            context 'when reimbursing' do
                              before do
                                job.reimburse_payment!
                              end

                              it 'billing status should be paid' do
                                expect(job.billing_status_name).to eq :paid
                              end

                              it 'customer balance should be flat' do
                                expect(job.customer.account.balance).to eq Money.new(0)
                              end
                            end

                          end

                        end


                      end

                    end

                  end

                end

              end

            end

          end
        end


      end
    end

  end

  describe 'collecting payment after the job is done' do

    before do
      complete_the_work job
    end

    context 'when and collecting partial amount' do
      before do
        collect_a_payment job, amount: 50, type: 'cheque', collector: job.subcontractor
      end

      it 'should allow the collection of additional payments' do
        expect(job.billing_status_events).to include :collect
      end

      it 'billing status should be partially_collected' do
        expect(job.billing_status_name).to eq :partially_collected
      end


      context 'when depositing the collection on behalf of the subcon' do
        before do
          job.collected_entries.last.deposited!
        end

        it 'should allow the collection of additional payments' do
          expect(job.billing_status_events).to include :collect
        end

        it 'billing status should be partially_collected' do
          expect(job.billing_status_name).to eq :partially_collected
        end


        context 'when depositing the customer payment' do
          before do
            job.payments.last.deposit!
          end

          it 'should allow the collection of additional payments' do
            expect(job.billing_status_events).to include :collect
          end

          it 'billing status should be partially_collected' do
            expect(job.billing_status_name).to eq :partially_collected
          end


          context 'when collecting the full amount' do
            before do
              collect_full_amount job, collector: job.subcontractor, type: 'cash'
              job.reload
            end

            it 'should not allow the collection of additional payments' do
              expect(job.billing_status_events).to_not include :collect
            end

            it 'billing status should be in_process' do
              expect(job.billing_status_name).to eq :in_process
            end


            context 'when customer cheque is rejected' do
              before do
                job.payments.order('ID ASC').first.reject!
                job.reload
              end

              it 'should allow the collection of additional payments' do
                expect(job.billing_status_events).to include :late
                expect(job.billing_status_events).to include :collect
              end

              it 'billing status should be rejected' do
                expect(job.billing_status_name).to eq :rejected
              end


              context 'when depositing the cash payment' do
                before do
                  job.collected_entries.order('ID DESC').first.deposited!
                  job.reload
                end

                context 'when depositing the customer payment' do
                  before do
                    job.payments.order('ID ASC').last.deposit!
                  end

                  it 'should allow the collection of additional payments' do
                    expect(job.billing_status_events).to include :late
                    expect(job.billing_status_events).to include :collect
                  end

                end

              end

            end

          end
        end
      end


    end


  end
end