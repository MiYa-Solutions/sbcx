require 'spec_helper'

describe 'My Service Call When I Do The Work' do

  include_context 'basic job testing'

  context 'when I create the job' do

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

    it 'user collection ebents should be the only available billing status' do
      expect(job.billing_status_events).to include :late, :collect
    end

    it 'subcontractor status should be na' do
      expect(job.subcontractor_status_name).to eq :na
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

        it 'available billing events should be [:collect, :late, :reopen]' do
          expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
        end

        describe 'collecting payment' do
          describe 'collecting full payment' do
            include_examples 'successful customer payment collection', 'collect' do
              let(:collection_job) { job }
              let(:collector) { job.organization.users.last }
              let(:billing_status) { :partially_collected }        # since the job is not done it is set to partial
              let(:billing_status_events) { [:collect, :deposited] }
              let(:billing_status_4_cash) { :partially_collected } # since the job is not done it is set to partial
              let(:billing_status_events_4_cash) { [:collect, :deposited] }
              let(:customer_balance_before_payment) { 0 }
              let(:payment_amount) { 100 }
              let(:job_events) { [ScCollectEvent] }

              let(:subcon_collection_status_4_cash) { nil }
              let(:prov_collection_status_4_cash) { nil }
              let(:subcon_collection_status) { nil }
              let(:prov_collection_status) { nil }
              let(:the_prov_job) { nil }

            end
          end

          describe 'collecting partial payment' do
            include_examples 'successful customer payment collection', 'collect' do
              let(:collection_job) { job }
              let(:collector) { job.organization.users.last }
              let(:billing_status) { :partially_collected }        # since the job is not done it is set to partial
              let(:billing_status_events) { [:collect, :deposited] }
              let(:billing_status_4_cash) { :partially_collected } # since the job is not done it is set to partial
              let(:billing_status_events_4_cash) { [:collect, :deposited] }
              let(:customer_balance_before_payment) { 0 }
              let(:payment_amount) { 10 }
              let(:job_events) { [ScCollectEvent] }

              let(:subcon_collection_status_4_cash) { nil }
              let(:prov_collection_status_4_cash) { nil }
              let(:subcon_collection_status) { nil }
              let(:prov_collection_status) { nil }
              let(:the_prov_job) { nil }

            end
          end
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
            job.status_events.should =~ [:cancel, :transfer]
          end

          it 'available work events should be start' do
            job.work_status_events.should =~ [:start]
          end

          it '[:collect, :late, :reopen] are the available payment events' do
            expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
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
              add_bom_to_job job, price: 100, cost: 100, quantity: 1
              job.complete_work!
            end

            it 'payment events are [:collect, :late, :reopen]' do
              expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
            end

            context 'when collecting cash' do

              context 'when collecting the full amount' do
                before do
                  collect_a_payment job, type: 'cash', amount: 100, collector: technician
                end

                it 'status should be open' do
                  expect(job).to be_open
                end

                it 'work status should be done' do
                  expect(job).to be_work_done
                end

                it 'payment status should be collected' do
                  expect(job).to be_payment_collected
                end

                it 'cancel is not allowed as the work is done' do
                  job.status_events.should_not include :cancel
                end

                it 'there should be no available user permitted work events' do
                  expect(job.work_status_events).to_not include :collect, :late
                end

                it 'available payment events are deposit' do
                  expect(job.billing_status_events.sort).to eq [:deposited, :reopen]
                end

                it 'collect event is associated with the job' do
                  job.events.map(&:class).should =~ [ServiceCallDispatchEvent,
                                                     ServiceCallStartEvent,
                                                     ServiceCallCompleteEvent,
                                                     ScCollectEvent]
                end

                it 'the org admin is NOT allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_false
                end

                it 'the technician is not allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', technician, job)).to be_false
                end

                describe 'billing' do

                  describe 'customer billing' do
                    it 'customer balance should be zero' do
                      expect(job.customer.account.balance).to eq 0
                    end
                  end
                end


                context 'when the employee deposits the payment' do

                  before do
                    job.payment_amount = nil # this is to replicate a separate user request (as it impacts job.overpaid?)
                    job.payments.last.deposit!
                    job.reload
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

                  it 'available status events should be  close' do
                    job.status_events.should ==[:close]
                  end

                  it 'there should be no available work events except reopen' do
                    expect(job.work_status_events.sort).to eq  [:reopen]
                  end

                  # it 'there should be no available payment events as this is a cash payment (no clearing)' do
                  #   job.billing_status_events.should eq [:cancel]
                  # end

                  it 'employee deposited event is associated with the job' do
                    job.events.map(&:class).should =~ [ServiceCallStartEvent,
                                                       ServiceCallDispatchEvent,
                                                       ServiceCallCompleteEvent,
                                                       ScCollectEvent]
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

                # it 'payment status should be partial_payment_collected_by_employee' do
                #   expect(job.billing_status_name).to eq :partial_payment_collected_by_employee
                # end

                it 'no available status events' do
                  job.status_events.should == []
                end

                it 'there should be no available work events, except reopen' do
                  expect(job.work_status_events.sort).to eq  [:reopen]
                end

                it 'available payment events are [:cancel, :collect, :late, :reject, :reopen]' do
                  expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reject, :reopen]
                end

                it 'collect event is associated with the job' do
                  job.events.map(&:class).should include ScCollectEvent
                end

                # it 'the org admin is allowed to invoke the deposit event' do
                #   expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_true
                # end
                #
                # it 'the technician is not allowed to invoke the deposit event' do
                #   expect(event_permitted_for_job?('billing_status', 'deposited', technician, job)).to be_false
                # end


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

              it 'payment status should be collected' do
                expect(job.billing_status_name).to eq :collected
              end

              it 'available status events should be cancel' do
                job.status_events.should eq []
              end

              it 'there should be no available work events except reopen' do
                expect(job.work_status_events.sort).to eq [:reopn]
              end

              it 'available payment events are [:deposited, :reopen]' do
                expect(job.billing_status_events.sort).to eq [:deposited, :reopen]
              end

              it 'collect event is associated with the job' do
                job.events.map(&:class).should =~ [ServiceCallDispatchEvent,
                                                   ServiceCallStartEvent,
                                                   ServiceCallCompleteEvent,
                                                   ScCollectEvent]
              end

              it 'the org admin is NOT allowed to invoke the deposit event' do
                expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_false
              end

              it 'the technician is not allowed to invoke the deposit event' do
                expect(event_permitted_for_job?('billing_status', 'deposited', technician, job)).to be_false
              end


              context 'when the employee deposits the payment' do

                before do
                  job.payments.last.deposit!
                  job.reload
                end

                it 'status should be open' do
                  expect(job).to be_open
                end

                it 'work status should be done' do
                  expect(job).to be_work_done
                end

                it 'payment status should be in_process' do
                  expect(job.billing_status_name).to eq :in_process
                end

                it 'available status events should be cancel' do
                  expect(job.status_events).to eq []
                end

                it 'there should be no available work events except reopen' do
                  expect(job.work_status_events).to eq [:reopen]
                end

                it 'available payment events are [:reject, :reopen] but they are not permitted for the user' do
                  expect(job.billing_status_events).to eq [:reject, :reopen]
                  expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                  expect(event_permitted_for_job?('billing_status', 'reopen', org_admin, job)).to be_false
                end

                context 'when clearing the payment' do
                  before do
                    clear_all_entries job.payments
                    job.reload
                  end

                  it 'job billing status should be paid' do
                    expect(job.billing_status_name).to eq :paid
                  end

                end

                it 'deposit event is associated with the job' do
                  job.events.map(&:class).should include ScCollectEvent

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
          job.status_events.should =~ [:cancel, :transfer]
        end

        it 'available work events should be complete' do
          job.work_status_events.sort.should == [:cancel, :complete, :reset]
        end

        it '[:collect, :late, :reopen] are the available payment events' do
          expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
        end

        it 'start event is associated with the job' do
          job.events.map(&:class).should =~ [ServiceCallStartEvent]
        end

        context 'partial payment' do
          before do
            collect_a_payment job, type: 'cash', amount: '10'
          end

          it 'payment status should be partially collected' do
            expect(job.billing_status_name).to eq :partially_collected
          end

          it 'available payment events are [:cancel, :collect, :late, :reject, :reopen ]' do
            expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reject, :reopen ]
          end

          it 'payment event is associated with the job' do
            job.events.map(&:class).should =~ [ServiceCallStartEvent, ScCollectEvent]
          end

          it 'payment amount is the submitted one' do
            expect(job.events.where(type: 'ScCollectEvent').first.amount).to eq Money.new_with_amount(10)
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
                collect_a_payment job, amount: 100, type: 'cash'
                job.payment_amount = nil # to simulate a separate request (payment amount is a virtual attribute )
                add_bom_to_job job, price: 100, cost: 10, quantity: 1
                job.update_attributes(work_status_event: 'complete')
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be collected' do
                expect(job.billing_status_name).to eq :collected
              end

            end
            context 'when the preliminary payment was for a partial amount' do
              before do
                collect_a_payment job, amount: 10, type: 'cash'
                add_bom_to_job job, price: 100, cost: 10, quantity: 1
                job.update_attributes(work_status_event: 'complete')
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be partially_collected' do
                expect(job.billing_status_name).to eq :partially_collected
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
              job.status_events.should eq []
            end

            it 'there should be no available work events except reopen' do
              expect(job.work_status_events).to eq [:reopen]
            end

            it 'available payment events are [:collect, :late, :reopen]' do
              expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
            end

            it 'complete event is associated with the job' do
              job.events.map(&:class).should =~ [ServiceCallStartEvent, ServiceCallCompleteEvent]
            end

          end

        end

      end


    end

  end
end