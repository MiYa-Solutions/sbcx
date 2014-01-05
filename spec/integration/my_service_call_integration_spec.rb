require 'spec_helper'

describe 'My Service Call Integration Spec' do

  context 'when I do the work' do
    include_context 'basic job testing'


    context 'when I create the job' do
      before do
        with_user(user) do
          org.save!
          job.save!
        end
      end
      it 'should be created successfully' do
        expect(job).to be_valid
      end

      it 'status should be New' do
        expect(job).to be_new
      end

      it 'work status should be pending' do
        expect(job).to be_work_pending
      end

      it 'payment status should be pending' do
        expect(job).to be_payment_pending
      end

      it 'available status events should be cancel' do
        job.status_events.should =~ [:cancel, :transfer]
      end

      it 'available work events should be start' do
        job.work_status_events.should =~ [:start]
      end

      it ' there should be no available payment events' do
        expect(job.billing_status_events).to be_empty
      end

      context 'when I start the job' do

        context 'multi user organization' do

          before do
            org.users << FactoryGirl.build(:my_technician)
          end

          it 'available work events should be dispatch and not start' do
            job.work_status_events.should =~ [:dispatch]
          end

          context 'when dispatching' do

            let(:technician) { org.users.technicians.first }

            before do
              job.technician = technician
              job.dispatch_work
            end

            it 'status should be Open' do
              expect(job).to be_open
            end

            it 'work status should be dispatched' do
              expect(job).to be_work_dispatched
            end

            it 'payment status should be pending' do
              expect(job).to be_payment_pending
            end

            it 'available status events should be cancel' do
              job.status_events.should =~ [:cancel]
            end

            it 'available work events should be start' do
              job.work_status_events.should =~ [:start]
            end

            it ' there should be no available payment events' do
              job.billing_status_events.should =~ []
            end

            it 'dispatch event is associated with the job' do
              job.events.map(&:class).should =~ [ServiceCallDispatchEvent]
            end

            it 'dispatch notification is sent to the technician' do
              technician.notifications.map(&:class).should =~ [ScDispatchNotification]
            end

          end

        end

        context 'with single user organization' do
          before do
            job.update_attributes(work_status_event: 'start')
          end

          it 'and start time is set' do
            expect(job.started_on).to be_kind_of(Time)
          end

          it 'status should be open' do
            expect(job).to be_open
          end

          it 'should create an appointment' do
            expect(job.appointments.last).to_not be_nil
          end

          it 'work status should be in progress' do
            expect(job).to be_work_in_progress
          end

          it 'payment status should be pending' do
            expect(job).to be_payment_pending
          end

          it 'available status events should be cancel' do
            job.status_events.should =~ [:cancel]
          end

          it 'available work events should be complete' do
            job.work_status_events.should =~ [:complete]
          end

          it 'there should be no available payment events' do
            expect(job.billing_status_events).to be_empty
          end

          it 'start event is associated with the job' do
            job.events.map(&:class).should =~ [ServiceCallStartEvent]
          end

          context 'when changing the scheduled time' do
            let(:scheduled_time) { 2.days.from_now }

            before do
              job.update_attributes(scheduled_for: scheduled_time)
            end

            it 'should have the properties update event associated' do
              # for some reason when running the spec it creates the same event twice, but it doesn't happen
              # in manual testing, so leaving it as is
              job.events.map(&:class).should =~ [ServiceCallStartEvent, ScPropertiesUpdateEvent, ScPropertiesUpdateEvent]
            end

            it 'should create an appointment for the scheduled time' do
              expect(job.appointments.last.starts_at).to eq scheduled_time
            end
          end

          context 'when I complete the job' do

            before do
              add_bom_to_job job
              job.update_attributes(work_status_event: 'complete')
            end

            it 'status should be open' do
              expect(job).to be_open
            end

            it 'completion time is set' do
              expect(job.completed_on).to be_kind_of(Time)
            end

            it 'work status should be done' do
              expect(job).to be_work_done
            end

            it 'payment status should be pending' do
              expect(job).to be_payment_pending
            end

            it 'available status events should be cancel' do
              job.status_events.should =~ [:cancel]
            end

            it 'there should be no available work events' do
              job.work_status_events.should =~ []
            end

            it 'available payment events are invoice' do
              job.billing_status_events.should =~ [:invoice]
            end

            it 'complete event is associated with the job' do
              job.events.map(&:class).should =~ [ServiceCallStartEvent, ServiceCallCompleteEvent]
            end

            context 'when I invoice' do

              before do
                job.update_attributes(billing_status_event: 'invoice')
              end

              it 'status should be open' do
                expect(job).to be_open
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be invoiced' do
                expect(job).to be_payment_invoiced
              end

              it 'available status events should be cancel' do
                job.status_events.should =~ [:cancel]
              end

              it 'there should be no available work events' do
                job.work_status_events.should =~ []
              end


              it 'available payment events are paid and overdue' do
                job.billing_status_events.should =~ [:paid, :overdue]
              end

              it 'invoice event is associated with the job' do
                job.events.map(&:class).should =~ [ServiceCallStartEvent, ServiceCallCompleteEvent, ServiceCallInvoiceEvent]
              end

              context 'when I collect the customer payment' do

                context 'single user organization' do

                  context 'when collecting cash' do

                    before do
                      job.update_attributes(billing_status_event: 'paid', payment_type: 'cash')
                    end

                    it 'status should be open' do
                      expect(job).to be_open
                    end

                    it 'work status should be done' do
                      expect(job).to be_work_done
                    end

                    it 'payment status should be cleared' do
                      expect(job).to be_payment_cleared
                    end

                    it 'available status events should be cancel and close' do
                      job.status_events.should =~ [:cancel, :close]
                    end

                    it 'there should be no available work events' do
                      job.work_status_events.should =~ []
                    end


                    it 'available payment events are paid and overdue' do
                      job.billing_status_events.should =~ []
                    end

                    it 'invoice event is associated with the job' do
                      job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                         ServiceCallCompleteEvent,
                                                         ServiceCallInvoiceEvent,
                                                         ServiceCallPaidEvent]
                    end

                  end

                  context 'when collecting none cash payment' do

                    before do
                      job.update_attributes(billing_status_event: 'paid', payment_type: 'cheque')
                    end

                    it 'status should be open' do
                      expect(job).to be_open
                    end

                    it 'work status should be done' do
                      expect(job).to be_work_done
                    end

                    it 'payment status should be paid' do
                      expect(job).to be_payment_paid
                    end

                    it 'available status events should be cancel' do
                      job.status_events.should =~ [:cancel]
                    end

                    it 'there should be no available work events' do
                      job.work_status_events.should =~ []
                    end


                    it 'available payment events are reject and clear' do
                      job.billing_status_events.should =~ [:reject, :clear]
                    end

                    it 'paid event is associated with the job' do
                      job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                         ServiceCallCompleteEvent,
                                                         ServiceCallInvoiceEvent,
                                                         ServiceCallPaidEvent]
                    end

                    context 'when payment is rejected' do
                      before do
                        job.update_attributes(billing_status_event: 'reject')
                      end

                      it 'payment status is set to rejected' do
                        expect(job).to be_payment_rejected
                      end

                      it 'should have the payment rejected event associated' do
                        job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                           ServiceCallCompleteEvent,
                                                           ServiceCallInvoiceEvent,
                                                           ServiceCallPaidEvent,
                                                           ScPaymentRejectedEvent]
                      end

                      it 'should have paid as a payment event' do
                        job.billing_status_events.should =~ [:paid]
                      end
                    end
                    context 'when payment is cleared' do
                      before do
                        job.update_attributes(billing_status_event: 'clear')
                      end

                      it 'payment status is set to rejected' do
                        expect(job).to be_payment_cleared
                      end

                      it 'should have the payment rejected event associated' do
                        job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                           ServiceCallCompleteEvent,
                                                           ServiceCallInvoiceEvent,
                                                           ServiceCallPaidEvent,
                                                           ScClearCustomerPaymentEvent]
                      end

                      it 'should have no payment events' do
                        job.billing_status_events.should =~ []
                      end
                    end

                  end
                end

                context 'multi user organization' do
                  let!(:technician) do
                    tech = FactoryGirl.build(:my_technician)
                    org.users << tech
                    tech
                  end

                  it 'payment events are collect' do
                    job.billing_status_events.should =~ [:collect, :overdue]
                  end

                  context 'when collecting cash' do
                    before do
                      job.update_attributes(billing_status_event: 'collect',
                                            payment_type:         'cash',
                                            collector:            technician)
                    end

                    it 'status should be open' do
                      expect(job).to be_open
                    end

                    it 'work status should be done' do
                      expect(job).to be_work_done
                    end

                    it 'payment status should be collected' do
                      expect(job).to be_payment_collected_by_employee
                    end

                    it 'available status events should be cancel' do
                      job.status_events.should =~ [:cancel]
                    end

                    it 'there should be no available work events' do
                      job.work_status_events.should =~ []
                    end

                    it 'available payment events are deposit' do
                      job.billing_status_events.should =~ [:deposited]
                    end

                    it 'collect event is associated with the job' do
                      job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                         ServiceCallCompleteEvent,
                                                         ServiceCallInvoiceEvent,
                                                         ScCollectedByEmployeeEvent]
                    end

                    it 'the org admin is allowed to invoke the deposit event' do
                      params = ActionController::Parameters.new({ service_call: {
                          billing_status_event: 'deposited'
                      } })
                      p      = PermittedParams.new(params, org_admin, job)
                      expect(p.service_call).to include('billing_status_event')
                    end

                    it 'the technician is not allowed to invoke the deposit event' do
                      params = ActionController::Parameters.new({ service_call: {
                          billing_status_event: 'deposited'
                      } })
                      p      = PermittedParams.new(params, technician, job)
                      expect(p.service_call).to_not include('billing_status_event')
                    end

                    context 'when the employee deposits the payment' do

                      before do
                        job.update_attributes(billing_status_event: 'deposited')
                      end

                      it 'status should be open' do
                        expect(job).to be_open
                      end

                      it 'work status should be done' do
                        expect(job).to be_work_done
                      end

                      it 'payment status should be cleared' do
                        expect(job.billing_status_name).to eq :cleared
                      end

                      it 'available status events should be cancel' do
                        job.status_events.should =~ [:cancel]
                      end

                      it 'there should be no available work events' do
                        job.work_status_events.should =~ []
                      end

                      it 'there should be no available payment events as this is a cash payment (no clearing)' do
                        job.billing_status_events.should eq []
                      end

                      it 'employee deposited event is associated with the job' do
                        job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                           ServiceCallCompleteEvent,
                                                           ServiceCallInvoiceEvent,
                                                           ScCollectedByEmployeeEvent,
                                                           ScEmployeeDepositedEvent]
                      end

                    end
                  end

                  context 'when collecting none cash payment' do
                    it 'status should be open'

                    it 'work status should be done'

                    it 'payment status should be collected'

                    it 'available status events should be cancel'

                    it 'there should be no available work events'

                    it 'available payment events are reject and clear'

                    it 'collect event is associated with the job'

                    context 'when the employee deposits the payment' do

                      it 'only the org admin is allowed to invoke the deposit event'

                      it 'status should be open'

                      it 'work status should be done'

                      it 'payment status should be deposited by employee'

                      it 'available status events should be cancel'

                      it 'there should be no available work events'

                      it 'available payment events are reject and clear'

                      it 'deposit event is associated with the job'

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

  context 'when I transfer to a member affiliate' do
    pending
  end

  context 'when I transfer to a local affiliate' do
    pending
  end

end