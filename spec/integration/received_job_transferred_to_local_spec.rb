require 'spec_helper'

describe 'Received Job When Transferred To Local Subcon' do

  context 'when the collection is allowed' do

    context 'when I allow the collection', skip_basic_job: true do
      include_context 'job transferred from a local provider' do
        let(:collection_allowed?) { true }
        let(:transfer_allowed?) { true }
      end
      include_context 'job transferred to local subcon'
      let(:broker_job) { BrokerServiceCall.find job.id }
      before do
        user.save!
        job.update_attributes(status_event: 'accept')
        transfer_the_job
        user.destroy # a workaround for the factory to ensure a single user org
      end

      it 'the job should be a transferred service call' do
        expect(broker_job).to be_instance_of(BrokerServiceCall)
      end

      it 'should not create a subcon job' do
        expect(TransferredServiceCall.find_by_organization_id_and_ref_id(subcon.id, broker_job.ref_id)).to be_nil
      end

      it 'status should be transferred' do
        expect(broker_job.status_name).to eq :transferred
      end

      it 'the available status events should be: cancel and cancel transfer' do
        expect(broker_job.status_events).to eq [:cancel_transfer, :cancel]
        expect(event_permitted_for_job?('status', 'cancel', org_admin, broker_job)).to be_true
        expect(event_permitted_for_job?('status', 'cancel_transfer', org_admin, broker_job)).to be_true
      end

      it 'provider status should be pending' do
        expect(broker_job.provider_status_name).to eq :pending
      end

      it 'there should be no available provider events' do
        expect(broker_job.provider_status_events).to eq []
      end

      it 'subcon status should be pending' do
        expect(broker_job.subcontractor_status_name).to eq :pending
      end

      it 'there should be no available subcon events' do
        expect(broker_job.subcontractor_status_events).to eq []
      end

      it 'the available payment status events should be: collect' do
        expect(broker_job.billing_status_events).to eq [:collect]
      end

      it 'work status should be pending' do
        expect(broker_job.work_status_name).to eq :pending
      end

      it 'the available work status events should be: accept and reject' do
        expect(broker_job.work_status_events).to eq [:accept, :reject]
        expect(event_permitted_for_job?('work_status', 'accept', org_admin, broker_job)).to be_true
        expect(event_permitted_for_job?('work_status', 'reject', org_admin, broker_job)).to be_true
      end

      context 'when accepting on behalf of the subcon' do

        before do
          broker_job.update_attributes(work_status_event: 'accept')
        end

        it 'status should be accepted' do
          expect(broker_job.status_name).to eq :transferred
        end

        it 'the available status events should be: cancel' do
          expect(broker_job.status_events).to eq [:cancel_transfer, :cancel]
          expect(event_permitted_for_job?('status', 'cancel', org_admin, broker_job)).to be_true
          expect(event_permitted_for_job?('status', 'cancel_transfer', org_admin, broker_job)).to be_true
        end

        it 'provider status should be pending' do
          expect(broker_job.provider_status_name).to eq :pending
        end

        it 'there should be no available provider events' do
          expect(broker_job.provider_status_events).to eq []
        end

        it 'subcon status should be pending' do
          expect(broker_job.subcontractor_status_name).to eq :pending
        end

        it 'there should be no available subcon events' do
          expect(broker_job.subcontractor_status_events).to eq []
        end

        it 'payment status should be na' do
          expect(broker_job.billing_status_name).to eq :na
        end

        it 'the available payment status events should be: collect' do
          expect(broker_job.billing_status_events).to eq [:collect]
        end

        it 'work status should be accepted' do
          expect(broker_job.work_status_name).to eq :accepted
        end

        it 'start should be available as the only work status event' do
          expect(broker_job.work_status_events).to eq [:start]
          expect(event_permitted_for_job?('work_status', 'start', org_admin, broker_job)).to be_true
        end

        context 'when started the work' do

          before do
            broker_job.update_attributes(work_status_event: 'start')
          end

          it 'status should be accepted' do
            expect(broker_job.status_name).to eq :transferred
          end

          it 'the available status events should be: cancel' do
            expect(broker_job.status_events).to eq [:cancel_transfer, :cancel]
            expect(event_permitted_for_job?('status', 'cancel', org_admin, broker_job)).to be_true
            expect(event_permitted_for_job?('status', 'cancel_transfer', org_admin, broker_job)).to be_true
          end

          it 'provider status should be pending' do
            expect(broker_job.provider_status_name).to eq :pending
          end

          it 'there should be no available provider events' do
            expect(broker_job.provider_status_events).to eq []
          end

          it 'subcon status should be pending' do
            expect(broker_job.subcontractor_status_name).to eq :pending
          end

          it 'there should be no available subcon events' do
            expect(broker_job.subcontractor_status_events).to eq []
          end

          it 'the available payment status events should be: :collect' do
            expect(broker_job.billing_status_events).to eq [:collect]
          end

          it 'work status should be in progress' do
            expect(broker_job.work_status_name).to eq :in_progress
          end

          it 'complete should be available as the only work status event' do
            expect(broker_job.work_status_events).to eq [:complete]
            expect(event_permitted_for_job?('work_status', 'complete', org_admin, broker_job)).to be_true
          end

          context 'when completed the broker_job' do
            before do
              add_bom_to_job broker_job, buyer: broker_job.subcontractor
              broker_job.update_attributes(work_status_event: 'complete')
            end

            it 'status should be transferred' do
              expect(broker_job.status_name).to eq :transferred
            end

            it 'the available status events should be: cancel' do
              expect(broker_job.status_events).to eq [:cancel]
              expect(event_permitted_for_job?('status', 'cancel', org_admin, broker_job)).to be_true
            end

            it 'provider status should be pending' do
              expect(broker_job.provider_status_name).to eq :pending
            end

            it 'there should be no available provider events' do
              expect(broker_job.provider_status_events).to eq []
            end

            it 'subcon status should be pending' do
              expect(broker_job.subcontractor_status_name).to eq :pending
            end

            it 'settlement with the subcon should be allowed' do
              expect(broker_job.subcontractor_status_events).to eq [:settle]
            end


            it 'the available payment events should be: invoice, invoiced by prov, invoiced by subcon, collect, provider_collected, subcon_collected' do
              expect(broker_job.billing_status_events).to eq [:collect]
              expect(event_permitted_for_job?('billing_status', 'collect', org_admin, broker_job)).to be_true
            end

            it 'work status should be done' do
              expect(broker_job.work_status_name).to eq :done
            end

            it 'there should be no available work status events' do
              expect(broker_job.work_status_events).to eq []
            end

            context 'when I invoice' do

              before do
                broker_job.update_attributes(billing_status_event: 'invoice')
              end

              it 'status should be accepted' do
                expect(broker_job.status_name).to eq :transferred
              end

              it 'the available status events should be: cancel' do
                expect(broker_job.status_events).to eq [:cancel]
                expect(event_permitted_for_job?('status', 'cancel', org_admin, broker_job)).to be_true
              end

              it 'provider status should be pending' do
                expect(broker_job.provider_status_name).to eq :pending
              end

              it 'there should be no available provider events' do
                expect(broker_job.provider_status_events).to eq []
              end

              it 'subcon status should be pending' do
                expect(broker_job.subcontractor_status_name).to eq :pending
              end

              it 'settlement with the subcon should be allowed' do
                expect(broker_job.subcontractor_status_events).to eq [:settle]
              end

              it 'payment status should be invoiced' do
                expect(broker_job.billing_status_name).to eq :invoiced
              end

              it 'the available payment events should be: collect and provider_collected' do
                expect(broker_job.billing_status_events).to eq [:provider_collected, :collect]
                expect(event_permitted_for_job?('billing_status', 'collect', org_admin, broker_job)).to be_true
                expect(event_permitted_for_job?('billing_status', 'provider_collected', org_admin, broker_job)).to be_true
              end

              it 'work status should be done' do
                expect(broker_job.work_status_name).to eq :done
              end

              it 'there should be no available work status events' do
                expect(broker_job.work_status_events).to eq []
              end

              context 'when I collect' do

                context 'when collecting cash' do
                  before do
                    broker_job.update_attributes(billing_status_event: 'collect',
                                          payment_type:         'cash',
                                          payment_amount:       '10000',
                                          collector:            broker_job.subcontractor)
                    broker_job.payment_amount = nil # to simulate a new user request, so removing the virtual attr value
                  end

                  it 'status should be transferred' do
                    expect(broker_job.status_name).to eq :transferred
                  end

                  it 'the available status events should be: cancel' do
                    expect(broker_job.status_events).to eq [:cancel]
                    expect(event_permitted_for_job?('status', 'cancel', org_admin, broker_job)).to be_true
                  end

                  it 'provider status should be pending' do
                    expect(broker_job.provider_status_name).to eq :pending
                  end

                  it 'there should be no available provider events' do
                    expect(broker_job.provider_status_events).to eq []
                  end

                  it 'subcon status should be pending' do
                    expect(broker_job.subcontractor_status_name).to eq :pending
                  end

                  it 'settlement with the subcon should be allowed' do
                    expect(broker_job.subcontractor_status_events).to eq [:settle]
                  end

                  it 'payment status should be collected' do
                    expect(broker_job.billing_status_name).to eq :collected
                  end

                  it 'the available payment events should be: deposit_to_prov' do
                    expect(broker_job.billing_status_events).to eq [:deposit_to_prov]
                    expect(event_permitted_for_job?('billing_status', 'deposit_to_prov', org_admin, broker_job)).to be_true
                  end

                  it 'work status should be done' do
                    expect(broker_job.work_status_name).to eq :done
                  end

                  it 'there should be no available work status events' do
                    expect(broker_job.work_status_events).to eq []
                  end

                  context 'when deposited to provider' do
                    before do
                      broker_job.update_attributes(billing_status_event: 'deposit_to_prov')
                    end

                    it 'status should be transferred' do
                      expect(broker_job.status_name).to eq :transferred
                    end

                    it 'the available status events should be: cancel' do
                      expect(broker_job.status_events).to eq [:cancel]
                      expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                    end

                    it 'provider status should be pending' do
                      expect(broker_job.provider_status_name).to eq :pending
                    end

                    it 'there should be no available provider events' do
                      expect(broker_job.provider_status_events).to eq []
                    end

                    it 'subcon status should be pending' do
                      expect(broker_job.subcontractor_status_name).to eq :pending
                    end

                    it 'payment status should be deposited_to_prov' do
                      expect(broker_job.billing_status_name).to eq :deposited_to_prov
                    end

                    it 'the available payment events should be: prov_confirmed_deposit' do
                      expect(broker_job.billing_status_events).to eq [:prov_confirmed_deposit]
                      expect(event_permitted_for_job?('billing_status', 'prov_confirmed_deposit', org_admin, job)).to be_true
                    end

                    it 'work status should be done' do
                      expect(broker_job.work_status_name).to eq :done
                    end

                    it 'there should be no available work status events' do
                      expect(broker_job.work_status_events).to eq []
                    end

                    context 'when provider confirms the deposit' do
                      before do
                        broker_job.update_attributes(billing_status_event: 'prov_confirmed_deposit')
                      end

                      it 'status should be transferred' do
                        expect(broker_job.status_name).to eq :transferred
                      end

                      it 'the available status events should be: cancel' do
                        expect(broker_job.status_events).to eq [:cancel]
                        expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                      end

                      it 'provider status should be pending' do
                        expect(broker_job.provider_status_name).to eq :pending
                      end

                      it 'the provider status events should be: settle' do
                        expect(broker_job.provider_status_events).to eq [:settle]
                        expect(event_permitted_for_job?('provider_status', 'settle', org_admin, job)).to be_true
                      end

                      it 'subcon status should be pending' do
                        expect(broker_job.subcontractor_status_name).to eq :pending
                      end

                      it 'payment status should be deposited' do
                        expect(broker_job.billing_status_name).to eq :deposited
                      end

                      it 'there should be no available payment events' do
                        expect(broker_job.billing_status_events).to eq []
                      end

                      it 'work status should be done' do
                        expect(broker_job.work_status_name).to eq :done
                      end

                      it 'there should be no available work status events' do
                        expect(broker_job.work_status_events).to eq []
                      end

                      context 'when settling with the provider' do

                        context 'when using cash' do

                          before do
                            broker_job.update_attributes(provider_status_event: 'settle', provider_payment: 'cash')
                          end

                          it 'status should be transferred' do
                            expect(broker_job.status_name).to eq :transferred
                          end

                          it 'the available status events should be: cancel' do
                            expect(broker_job.status_events).to eq [:cancel]
                            expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                          end

                          it 'provider status should be cleared' do
                            expect(broker_job.provider_status_name).to eq :cleared
                          end

                          it 'there should be no provider status events' do
                            expect(broker_job.provider_status_events).to eq []
                          end

                          it 'subcon status should be pending' do
                            expect(broker_job.subcontractor_status_name).to eq :pending
                          end

                          it 'payment status should be deposited' do
                            expect(broker_job.billing_status_name).to eq :deposited
                          end

                          it 'there should be no available payment events' do
                            expect(broker_job.billing_status_events).to eq []
                          end

                          it 'work status should be done' do
                            expect(broker_job.work_status_name).to eq :done
                          end

                          it 'there should be no available work status events' do
                            expect(broker_job.work_status_events).to eq []
                          end

                        end

                        context 'when using a cheque' do

                          before do
                            broker_job.update_attributes(provider_status_event: 'settle', provider_payment: 'cheque')
                          end

                          it 'status should be transferred' do
                            expect(broker_job.status_name).to eq :transferred
                          end

                          it 'the available status events should be: cancel' do
                            expect(broker_job.status_events).to eq [:cancel]
                            expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                          end

                          it 'provider status should be settled' do
                            expect(broker_job.provider_status_name).to eq :settled
                          end

                          it 'provider status events should be: clear' do
                            expect(broker_job.provider_status_events).to eq [:clear]
                            expect(event_permitted_for_job?('provider_status', 'clear', org_admin, job)).to be_true
                          end

                          it 'subcon status should be pending' do
                            expect(broker_job.subcontractor_status_name).to eq :pending
                          end

                          it 'payment status should be deposited' do
                            expect(broker_job.billing_status_name).to eq :deposited
                          end

                          it 'there should be no available payment events' do
                            expect(broker_job.billing_status_events).to eq []
                          end

                          it 'work status should be done' do
                            expect(broker_job.work_status_name).to eq :done
                          end

                          it 'there should be no available work status events' do
                            expect(broker_job.work_status_events).to eq []
                          end

                          context 'when provider clears the payment' do

                            before do
                              broker_job.update_attributes(provider_status_event: 'clear')
                            end

                            it 'status should be transferred' do
                              expect(broker_job.status_name).to eq :transferred
                            end

                            it 'the available status events should be: cancel' do
                              expect(broker_job.status_events).to eq [:cancel]
                              expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                            end

                            it 'provider status should be cleared' do
                              expect(broker_job.provider_status_name).to eq :cleared
                            end

                            it 'there should be no provider status events available' do
                              expect(broker_job.provider_status_events).to eq []
                            end

                            it 'subcon status should be pending' do
                              expect(broker_job.subcontractor_status_name).to eq :pending
                            end

                            it 'payment status should be deposited' do
                              expect(broker_job.billing_status_name).to eq :deposited
                            end

                            it 'there should be no available payment events' do
                              expect(broker_job.billing_status_events).to eq []
                            end

                            it 'work status should be done' do
                              expect(broker_job.work_status_name).to eq :done
                            end

                            it 'there should be no available work status events' do
                              expect(broker_job.work_status_events).to eq []
                            end

                            context 'when settling with the subcon' do

                              context 'when using a cheque' do

                                before do
                                  broker_job.update_attributes(subcontractor_status_event: 'settle', subcon_payment: 'cheque')
                                end

                                it 'status should be transferred' do
                                  expect(broker_job.status_name).to eq :transferred
                                end

                                it 'the available status events should be: cancel' do
                                  expect(broker_job.status_events).to eq [:cancel]
                                  expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                                end

                                it 'provider status should be cleared' do
                                  expect(broker_job.provider_status_name).to eq :cleared
                                end

                                it 'there should be no provider status events available' do
                                  expect(broker_job.provider_status_events).to eq []
                                end

                                it 'subcon status should be settled' do
                                  expect(broker_job.subcontractor_status_name).to eq :settled
                                end

                                it 'payment status should be deposited' do
                                  expect(broker_job.billing_status_name).to eq :deposited
                                end

                                it 'there should be no available payment events' do
                                  expect(broker_job.billing_status_events).to eq []
                                end

                                it 'work status should be done' do
                                  expect(broker_job.work_status_name).to eq :done
                                end

                                it 'there should be no available work status events' do
                                  expect(broker_job.work_status_events).to eq []
                                end

                                it 'subcon status available events should be clear' do
                                  expect(broker_job.subcontractor_status_events).to eq [:clear]
                                end

                                context 'when the subcontractor cheque payment is cleared' do
                                  before do
                                    broker_job.update_attributes(subcontractor_status_event: 'clear')
                                  end

                                  it 'subcon status should be cleared' do
                                    expect(broker_job.subcontractor_status_name).to eq :cleared
                                  end

                                  context 'when closing the job' do

                                    before do
                                      broker_job.update_attributes(status_event: 'close')
                                    end

                                    it 'status should be closed' do
                                      expect(broker_job.status_name).to eq :closed
                                    end

                                    it 'there should be no available status events' do
                                      expect(broker_job.status_events).to eq []
                                    end

                                    it 'provider status should be cleared' do
                                      expect(broker_job.provider_status_name).to eq :cleared
                                    end

                                    it 'there should be no provider status events available' do
                                      expect(broker_job.provider_status_events).to eq []
                                    end

                                    it 'subcon status should be cleared' do
                                      expect(broker_job.subcontractor_status_name).to eq :cleared
                                    end

                                    it 'payment status should be deposited' do
                                      expect(broker_job.billing_status_name).to eq :deposited
                                    end

                                    it 'there should be no available payment events' do
                                      expect(broker_job.billing_status_events).to eq []
                                    end

                                    it 'work status should be done' do
                                      expect(broker_job.work_status_name).to eq :done
                                    end

                                    it 'there should be no available work status events' do
                                      expect(broker_job.work_status_events).to eq []
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

                context 'when collecting none cash'

              end

              context 'when the provider collects'


            end

            context 'when provider invoices'

            context 'when I invoice on behalf of the subcon'

          end


        end

      end

      context 'when rejected'


    end

    context 'when I don' 't allow the collection'


  end

  context 'when the collection is not allowed' do
    pending
  end

end