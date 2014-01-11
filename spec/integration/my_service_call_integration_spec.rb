require 'spec_helper'

shared_context 'when canceling the job' do
  before do
    job_to_cancel.update_attributes(status_event: 'cancel') unless example.metadata[:skip_cancel]
  end

  it 'should allow to cancel the job', skip_cancel: true do
    expect(job_to_cancel.status_events).to include(:cancel)
  end
end

shared_examples 'provider job is canceled' do
  it 'job status should be canceled' do
    expect(job.reload).to be_canceled
  end
end

shared_examples 'subcon job is canceled' do

  it 'subcon job status should be canceled' do
    expect(subcon_job.reload).to be_canceled
  end
end

shared_context 'when the subcon cancels the job' do
  include_context 'when canceling the job' do
    let(:job_to_cancel) { subcon_job }
  end
end

shared_context 'when the provider cancels the job' do
  include_context 'when canceling the job' do
    let(:job_to_cancel) { job }
  end
end

shared_examples 'provider job canceled after completion' do
  pending 'verify reimbursement'
end

shared_examples 'subcon job canceled after completion' do
  pending 'verify reimbursement'
end


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

      context 'when prov cancels' do
        include_context 'when the provider cancels the job'
        it_should_behave_like 'provider job is canceled'
      end


      context 'when I start the job' do

        context 'multi user organization' do
          let!(:technician) do
            tech = FactoryGirl.build(:my_technician)
            org.users << tech
            tech
          end

          it 'available work events should be dispatch and not start' do
            job.work_status_events.should =~ [:dispatch]
          end

          context 'when dispatching' do

            before do
              job.update_attributes(technician: technician, work_status_event: 'dispatch')
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

            context 'when collecting payment' do

              before do
                job.start_work!
                add_bom_to_job job
                job.complete_work!
                job.invoice_payment!
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
                  job.events.map(&:class).should =~ [ServiceCallDispatchEvent,
                                                     ServiceCallStartEvent,
                                                     ServiceCallCompleteEvent,
                                                     ServiceCallInvoiceEvent,
                                                     ScCollectedByEmployeeEvent]
                end

                it 'the org admin is allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_true
                end

                it 'the technician is not allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', technician, job)).to be_false
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

                  it 'available status events should be cancel and close' do
                    job.status_events.should =~ [:cancel, :close]
                  end

                  it 'there should be no available work events' do
                    job.work_status_events.should =~ []
                  end

                  it 'there should be no available payment events as this is a cash payment (no clearing)' do
                    job.billing_status_events.should eq []
                  end

                  it 'employee deposited event is associated with the job' do
                    job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                       ServiceCallDispatchEvent,
                                                       ServiceCallCompleteEvent,
                                                       ServiceCallInvoiceEvent,
                                                       ScCollectedByEmployeeEvent,
                                                       ScEmployeeDepositedEvent]
                  end

                end
              end

              context 'when collecting none cash payment' do

                before do
                  job.update_attributes(billing_status_event: 'collect',
                                        payment_type:         'credit_card',
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
                  job.events.map(&:class).should =~ [ServiceCallDispatchEvent,
                                                     ServiceCallStartEvent,
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

              context 'when prov cancels' do
                include_context 'when the provider cancels the job'
                it_should_behave_like 'provider job is canceled'
                it_should_behave_like 'provider job canceled after completion'
              end


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

            end

          end

        end


      end

    end

  end

  context 'when I transfer to a member affiliate' do
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

    it 'cancel should not be permitted job the subcon job' do
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

    it 'there should be no available payment events for the job' do
      expect(job.billing_status_events).to be_empty
    end

    it 'there should be no available payment events for the subcon job' do
      expect(subcon_job.billing_status_events).to be_empty
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

      it 'there should be no available payment events for the job' do
        expect(job.billing_status_events).to be_empty
      end

      it 'there should be no available payment events for the subcon job' do
        expect(subcon_job.billing_status_events).to be_empty
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

        it 'there should be no available payment events for the job' do
          expect(job.billing_status_events).to be_empty
        end

        it 'there should be no available payment events for the subcon job' do
          expect(subcon_job.billing_status_events).to be_empty
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

          it 'subcon job work status should be in progress' do
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
            expect(job.reload.billing_status_events).to eq [:invoice, :subcon_invoiced]
            expect(event_permitted_for_job?('billing_status', 'invoice', org_admin, job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'subcon_invoiced', org_admin, job)).to be_false
          end

          it 'subcon job should have invoice and provider invoiced as the available payment events, but provider invoiced is not permitted' do
            expect(subcon_job.billing_status_events).to eq [:invoice, :provider_invoiced]
            expect(event_permitted_for_job?('billing_status', 'invoice', subcon_admin, subcon_job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'provider_invoiced', subcon_admin, subcon_job)).to be_false
          end

          context 'when subcon invoices' do

          end

        end

      end


    end

    context 'when subcon rejects the job' do
      pending
    end


  end

  context 'when I transfer to a local affiliate' do
    pending
  end

end