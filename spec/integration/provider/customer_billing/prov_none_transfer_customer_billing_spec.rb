require 'spec_helper'

describe 'Customer Billing When Provider Didn\'t Transfer' do

  include_context 'basic job testing'


  context 'when I create the job' do
    before do
      with_user(user) do
        org.save!
        job.save!
      end
    end

    it 'payment status should be pending' do
      expect(job.billing_status).to eq :pending
    end

    it 'paid should be the only available billing status' do
      expect(job.billing_status_events).to eq [:paid]
    end

    context 'when I start the job' do

      context 'multi user organization' do
        let!(:technician) do
          tech = FactoryGirl.build(:my_technician)
          org.users << tech
          tech
        end

        it 'available billing events should be collect' do
          job.billing_status_events.should =~ [:collect]
        end

        describe 'collecting payment' do
          describe 'collecting full payment' do
            include_examples 'successful customer payment collection', 'collect' do
              let(:collection_job) { job }
              let(:collector) { job.organization.users.last }
              let(:billing_status) { :partial_payment_collected_by_employee }        # since the job is not done it is set to partial
              let(:billing_status_events) { [:collect, :deposited] }
              let(:billing_status_4_cash) { :partial_payment_collected_by_employee } # since the job is not done it is set to partial
              let(:billing_status_events_4_cash) { [:collect, :deposited] }
              let(:customer_balance_before_payment) { 0 }
              let(:payment_amount) { 100 }
              let(:job_events) { [ScCollectedByEmployeeEvent] }
            end
          end

          describe 'collecting partial payment' do
            include_examples 'successful customer payment collection', 'collect' do
              let(:collection_job) { job }
              let(:collector) { job.organization.users.last }
              let(:billing_status) { :partial_payment_collected_by_employee }        # since the job is not done it is set to partial
              let(:billing_status_events) { [:collect, :deposited] }
              let(:billing_status_4_cash) { :partial_payment_collected_by_employee } # since the job is not done it is set to partial
              let(:billing_status_events_4_cash) { [:collect, :deposited] }
              let(:customer_balance_before_payment) { 0 }
              let(:payment_amount) { 10 }
              let(:job_events) { [ScCollectedByEmployeeEvent] }
            end
          end
        end

        context 'when dispatching' do

          before do
            dispatch_the_job job, technician
          end

          it 'payment status should be pending' do
            expect(job.billing_status_name).to eq :pending
          end

          it 'collect is the only available payment events' do
            expect(job.billing_status_events.sort).to eq [:collect]
          end

          context 'when collecting payment' do

            context 'when collecting cash' do

              context 'when collecting the full amount' do
                before do
                  collect_a_payment job, event: 'collect', type: 'cash', amount: '100', collector: technician
                end

                it 'payment status should be payment_collected_by_employee' do
                  expect(job.billing_status_name).to eq :payment_collected_by_employee
                end

                it 'available payment events are deposit' do
                  job.billing_status_events.should =~ [:deposited]
                end

                it 'collect event is associated with the job' do
                  expect(job.events.map(&:class).sort).to eq [ScCollectedByEmployeeEvent, ServiceCallDispatchEvent]
                end

                it 'the org admin is allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_true
                end

                it 'the technician is not allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', technician, job)).to be_false
                end

                it 'customer balance should be zero' do
                  expect(job.customer.account.balance).to eq 0
                end


                context 'when the employee deposits the payment' do

                  before do
                    confirm_employee_deposit job.collection_entries.last
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

              context 'when collecting partial amount' do
                before do
                  job.update_attributes(billing_status_event: 'collect',
                                        payment_type:         'cash',
                                        payment_amount:       '10',
                                        collector:            technician)

                end

                it 'status should be open' do
                  expect(job).to be_open
                end

                it 'work status should be done' do
                  expect(job).to be_work_done
                end

                it 'payment status should be partial_payment_collected_by_employee' do
                  expect(job.billing_status_name).to eq :partial_payment_collected_by_employee
                end

                it 'available status events should be cancel' do
                  job.status_events.should =~ [:cancel]
                end

                it 'there should be no available work events' do
                  job.work_status_events.should =~ []
                end

                it 'available payment events are deposit' do
                  job.billing_status_events.should =~ [:deposited, :collect]
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


              end
            end

            context 'when collecting none cash payment' do

              before do
                job.update_attributes(billing_status_event: 'collect',
                                      payment_type:         'credit_card',
                                      payment_amount:       '100',
                                      collector:            technician)
              end

              it 'status should be open' do
                expect(job).to be_open
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be collected by employee' do
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

                it 'payment status should be paid' do
                  expect(job.billing_status_name).to eq :paid
                end

                it 'available status events should be cancel' do
                  expect(job.status_events).to eq [:cancel]
                  expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                end

                it 'there should be no available work events' do
                  expect(job.work_status_events).to eq []
                end

                it 'available payment events are reject and clear but they are not permitted for the user' do
                  expect(job.billing_status_events).to eq [:clear, :reject]
                  expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                  expect(event_permitted_for_job?('billing_status', 'clear', org_admin, job)).to be_false
                end

                it 'deposit event is associated with the job' do
                  job.events.map(&:class).should =~ [ServiceCallDispatchEvent,
                                                     ServiceCallStartEvent,
                                                     ServiceCallCompleteEvent,
                                                     ServiceCallInvoiceEvent,
                                                     ScCollectedByEmployeeEvent,
                                                     ScEmployeeDepositedEvent]

                end

              end

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

        it 'paid is the only available payment events' do
          expect(job.billing_status_events).to eq [:paid]
        end

        it 'start event is associated with the job' do
          job.events.map(&:class).should =~ [ServiceCallStartEvent]
        end

        context 'partial payment' do
          before do
            job.update_attributes(billing_status_event: 'paid', payment_type: 'cash', payment_amount: '10')
          end

          it 'payment status should be partially paid' do
            expect(job.billing_status_name).to eq :partially_paid
          end

          it 'available payment events are paid' do
            expect(job.billing_status_events).to eq [:paid]
          end

          it 'payment event is associated with the job' do
            job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                               ServiceCallPaidEvent]
          end

          it 'payment amount is the submitted one' do
            expect(job.events.where(type: 'ServiceCallPaidEvent').first.amount).to eq Money.new_with_amount(10)
          end

        end

        context 'when changing the scheduled time' do
          let(:scheduled_time) { 2.days.from_now }

          before do
            job.update_attributes(scheduled_for: scheduled_time)
          end

          it 'should have the properties update event associated' do
            job.events.map { |e| e.class.name }.should =~ ['ServiceCallStartEvent', 'ScPropertiesUpdateEvent']
          end

          it 'should create an appointment for the scheduled time' do
            expect(job.appointments.last.starts_at).to eq scheduled_time
          end
        end

        context 'when I complete the job' do

          context 'when a preliminary payment was made before the completion' do
            context 'when the preliminary payment was for the full amount' do
              before do
                job.update_attributes(billing_status_event: 'paid', payment_amount: '100', payment_type: 'cash')
                job.payment_amount = nil # to simulate a separate request (payment amount is a virtual attribute )
                add_bom_to_job job, price: 100, cost: 10, quantity: 1
                job.update_attributes(work_status_event: 'complete')
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be cleared' do
                expect(job.billing_status_name).to eq :cleared
              end

            end
            context 'when the preliminary payment was for a partial amount' do
              before do
                job.update_attributes(billing_status_event: 'paid', payment_amount: '10', payment_type: 'cash')
                job.payment_amount = nil # to simulate a separate request (payment amount is a virtual attribute )
                add_bom_to_job job, price: 100, cost: 10, quantity: 1
                job.update_attributes(work_status_event: 'complete')
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be partially_paid' do
                expect(job.billing_status_name).to eq :partially_paid
              end

            end
          end

          context 'when there was no preliminary payment' do
            before do
              add_bom_to_job job, price: 100, cost: 10, quantity: 1
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

            it 'available payment events are invoice and paid' do
              job.billing_status_events.should =~ [:invoice, :paid]
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

                  context 'when collecting the full payment' do
                    before do
                      job.update_attributes(billing_status_event: 'paid', payment_type: 'cash', payment_amount: '100')
                      job.payment_amount = nil # to simulate a separate request (payment amount is a virtual attribute )
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


                    it 'there are no available payment events' do
                      job.billing_status_events.should =~ []
                    end

                    it 'invoice event is associated with the job' do
                      job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                         ServiceCallCompleteEvent,
                                                         ServiceCallInvoiceEvent,
                                                         ServiceCallPaidEvent]
                    end
                  end

                  context 'when collecting partial payment' do
                    before do
                      job.update_attributes(billing_status_event: 'paid', payment_type: 'cash', payment_amount: '10')
                    end

                    it 'status should be open' do
                      expect(job).to be_open
                    end

                    it 'work status should be done' do
                      expect(job).to be_work_done
                    end

                    it 'payment status should be partially paid' do
                      expect(job.billing_status_name).to eq :partially_paid
                    end

                    it 'available status events should be cancel' do
                      job.status_events.should =~ [:cancel]
                    end

                    it 'there should be no available work events' do
                      job.work_status_events.should =~ []
                    end


                    it 'available payment events are paid and overdue' do
                      job.billing_status_events.should =~ [:overdue, :paid]
                    end

                    it 'payment event is associated with the job' do
                      job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                         ServiceCallCompleteEvent,
                                                         ServiceCallInvoiceEvent,
                                                         ServiceCallPaidEvent]
                    end
                    it 'payment amount is the submitted one' do
                      expect(job.events.where(type: 'ServiceCallPaidEvent').first.amount).to eq Money.new_with_amount(10)
                    end

                    describe 'billing' do
                      describe 'customer billing' do
                        it 'balance should be 10' do
                          expect(job.customer.account.reload.balance).to eq Money.new(10000 - 1000, 'USD')
                        end
                      end
                    end

                    context 'another partial payment' do
                      before do
                        job.update_attributes(billing_status_event: 'paid', payment_type: 'cash', payment_amount: '10')
                      end

                      it 'payment status should be partially paid' do
                        expect(job.billing_status_name).to eq :partially_paid
                      end

                      describe 'billing' do
                        describe 'customer billing' do
                          it 'balance should be 10' do
                            expect(job.customer.account.reload.balance).to eq Money.new(10000 - 2000, 'USD')
                          end
                        end
                      end

                      context 'when paying the remainder' do
                        before do
                          job.update_attributes(billing_status_event: 'paid', payment_type: 'cash', payment_amount: '80')
                        end

                        it 'payment status should be partially cleared' do
                          expect(job.billing_status_name).to eq :cleared
                        end

                      end


                    end

                  end

                end

                context 'when collecting none cash payment' do

                  context 'when collecting partial amount' do
                    before do
                      job.update_attributes(billing_status_event: 'paid', payment_type: 'cheque', payment_amount: '10')
                      job.payment_amount = nil # to simulate a separate request (payment amount is a virtual attribute )
                    end

                    it 'status should be open' do
                      expect(job).to be_open
                    end

                    it 'work status should be done' do
                      expect(job).to be_work_done
                    end

                    it 'payment status should be partially paid' do
                      expect(job.billing_status_name).to eq :partially_paid
                    end

                    it 'available status events should be cancel' do
                      job.status_events.should =~ [:cancel]
                    end

                    it 'there should be no available work events' do
                      job.work_status_events.should =~ []
                    end

                    it 'available payment events are reject, clear, overdue and paid' do
                      job.billing_status_events.should =~ [:reject, :clear, :overdue, :paid]
                    end

                    it 'payment events reject and clear are not allowed for a user' do
                      expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                      expect(event_permitted_for_job?('billing_status', 'clear', org_admin, job)).to be_false

                    end

                    it 'paid event is associated with the job' do
                      job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                         ServiceCallCompleteEvent,
                                                         ServiceCallInvoiceEvent,
                                                         ServiceCallPaidEvent]
                    end

                    context 'when payment is rejected' do
                      before do
                        job.payments.last.reject!
                        job.reload
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

                      it 'should have paid, clear and reject as possible payment events, but reject and clear are not permitted to a user' do
                        job.billing_status_events.should =~ [:clear, :paid, :reject]
                        expect(event_permitted_for_job?('billing_status', 'clear', org_admin, job)).to be_false
                        expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                        expect(event_permitted_for_job?('billing_status', 'paid', org_admin, job)).to be_true
                      end

                      context 'when adding another payment for the full amount' do
                        before do
                          job.update_attributes(billing_status_event: 'paid',
                                                payment_type:         'credit_card',
                                                payment_amount:       '100')
                          job.payment_amount = nil # to simulate a separate request (payment amount is a virtual attribute )
                        end

                        it 'payment status should be paid' do
                          expect(job.billing_status_name).to eq :paid
                        end

                        context 'when clearing the payment' do
                          include_context 'clear payment' do
                            let(:entry) { job.customer.account.payments.order('ID ASC').last }
                          end

                          it 'payment status is set to cleared' do
                            expect(job.reload.billing_status_name).to eq :cleared
                          end

                          it 'should have the payment cleared event associated' do
                            job.reload.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                                      ServiceCallCompleteEvent,
                                                                      ServiceCallInvoiceEvent,
                                                                      ServiceCallPaidEvent,
                                                                      ServiceCallPaidEvent,
                                                                      ScPaymentRejectedEvent,
                                                                      ScClearCustomerPaymentEvent]
                          end

                        end

                      end

                      context 'when adding another payment for the partial amount' do
                        before do
                          job.update_attributes(billing_status_event: 'paid',
                                                payment_type:         'credit_card',
                                                payment_amount:       '10')
                        end

                        it 'payment status should be partially paid' do
                          expect(job.billing_status_name).to eq :partially_paid
                        end

                        context 'when clearing the payment' do
                          include_context 'clear payment' do
                            let(:entry) { job.customer.account.payments.order('ID ASC').last }
                          end

                          it 'job payment status is set to partially paid' do
                            expect(job.reload.billing_status_name).to eq :partially_paid
                          end

                          it 'should have the payment cleared event associated' do
                            job.reload.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                                      ServiceCallCompleteEvent,
                                                                      ServiceCallInvoiceEvent,
                                                                      ServiceCallPaidEvent,
                                                                      ScPaymentRejectedEvent,
                                                                      ServiceCallPaidEvent]
                          end

                          context 'when paying additional payment (not the complete amount yet)' do
                            before do
                              job.update_attributes(billing_status_event: 'paid',
                                                    payment_type:         'cash',
                                                    payment_amount:       '70')

                            end

                            it 'payment status should be partially paid' do
                              expect(job.billing_status_name).to eq :partially_paid
                            end
                            context 'when paying additional payment for the remainder of the amount' do
                              before do
                                job.update_attributes(billing_status_event: 'paid',
                                                      payment_type:         'cash',
                                                      payment_amount:       '20')

                              end

                              it 'payment status should be cleared' do
                                expect(job.billing_status_name).to eq :cleared
                              end


                            end


                          end


                        end


                      end
                    end

                    context 'when payment is cleared' do
                      include_context 'clear payment' do
                        let(:entry) { job.customer.account.payments.order('ID ASC').last }
                      end

                      it 'payment status is set to partially paid' do
                        expect(job.billing_status_name).to eq :partially_paid
                      end

                      it 'should have paid overdue reject and clear events' do
                        job.billing_status_events.should =~ [:paid, :overdue, :reject, :clear]
                      end
                    end
                  end

                  context 'when collecting the full amount' do
                    before do
                      job.update_attributes(billing_status_event: 'paid', payment_type: 'cheque', payment_amount: '100')
                      job.payment_amount = nil # to simulate seperate request as payment is a virtual attr
                    end

                    it 'status should be open' do
                      expect(job).to be_open
                    end

                    it 'work status should be done' do
                      expect(job).to be_work_done
                    end

                    it 'payment status should be paid' do
                      expect(job.billing_status_name).to eq :paid
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

                      include_context 'reject payment' do
                        let(:entry) { job.customer.account.payments.order('ID ASC').last }
                      end

                      it 'payment status is set to rejected' do
                        expect(job.reload.billing_status_name).to eq :rejected
                      end

                      it 'should have the payment rejected event associated' do
                        job.reload.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                                  ServiceCallCompleteEvent,
                                                                  ServiceCallInvoiceEvent,
                                                                  ServiceCallPaidEvent,
                                                                  ScPaymentRejectedEvent]
                      end

                      it 'should have clear and reject as possible payment events, but they are not permitted to a user' do
                        job.billing_status_events.should =~ [:clear, :reject]
                        expect(event_permitted_for_job?('billing_status', 'clear', org_admin, job)).to be_false
                        expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                      end
                    end

                    context 'when payment is cleared' do
                      include_context 'clear payment' do
                        let(:entry) { job.customer.account.payments.order('ID ASC').last }
                      end

                      it 'payment status is set to cleared' do
                        expect(job.reload.billing_status_name).to eq :cleared
                      end

                      it 'should have the payment rejected event associated' do
                        job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                           ServiceCallCompleteEvent,
                                                           ServiceCallInvoiceEvent,
                                                           ServiceCallPaidEvent,
                                                           ScClearCustomerPaymentEvent]
                      end

                      it 'should have no payment events' do
                        job.reload.billing_status_events.should =~ []
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