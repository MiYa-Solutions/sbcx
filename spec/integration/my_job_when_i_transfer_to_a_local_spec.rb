require 'spec_helper'

describe 'My Job When I Transfer to a Local Affiliate' do
  include_context 'job transferred to local subcon'
  before do
    transfer_the_job
  end

  it 'the job status should be transferred' do
    expect(job).to be_transferred
  end

  it 'a job for the subcon should not be created' do
    expect(TransferredServiceCall.find_by_organization_id_and_ref_id(subcon.id, job.ref_id)).to be_nil
  end

  it 'job work status should be pending' do
    expect(job).to be_work_pending
  end

  it 'job payment status should be pending' do
    expect(job).to be_payment_pending
  end

  it 'job available status events should be cancel and cancel transfer' do
    job.status_events.should =~ [:cancel, :cancel_transfer]
  end

  it 'job should have accept and reject as available work events' do
    expect(job.work_status_events).to eq [:accept, :reject]
  end

  it 'accept and reject are permitted events for job when submitted by a user' do
    expect(event_permitted_for_job?('work_status', 'accept', org_admin, job)).to be_true
    expect(event_permitted_for_job?('work_status', 'reject', org_admin, job)).to be_true
  end

  it 'the available payment events for the job are: collect' do
    expect(job.billing_status_events).to eq [:collect]
    expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
  end

  it 'subcon status should be pending' do
    expect(job.subcontractor_status_name).to eq :pending
  end

  it 'should have no job available subcon events' do
    expect(job.subcontractor_status_events).to eq []
  end

  describe 'partial collection' do
    pending
  end

  context 'when canceled' do
    include_context 'when the provider cancels the job'
    it_should_behave_like 'provider job is canceled'
  end

  context 'when accepting on behalf of the subcon' do

    before do
      job.update_attributes(work_status_event: 'accept')
    end

    it 'the job status should be transferred' do
      expect(job).to be_transferred
    end

    it 'job work status should be accepted' do
      expect(job).to be_work_accepted
    end

    it 'job payment status should be pending' do
      expect(job).to be_payment_pending
    end

    it 'job available status events should be cancel abd cancel_transfer' do
      job.status_events.should =~ [:cancel, :cancel_transfer]
    end

    it 'job available work events are start' do
      expect(job.reload.work_status_events).to eq [:start]
      expect(event_permitted_for_job?('work_status', 'start', org_admin, job)).to be_true
    end

    it 'the available payment events for the job are collect and subcon collected' do
      expect(job.billing_status_events).to eq [:collect, :subcon_collected]
      expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
      expect(event_permitted_for_job?('billing_status', 'subcon_collected', org_admin, job)).to be_true
    end

    it 'subcon status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'should have no job available subcon events' do
      expect(job.subcontractor_status_events).to eq []
    end


    context 'when canceled' do
      include_context 'when the provider cancels the job'
      it_should_behave_like 'provider job is canceled'
    end

    context 'when starting the job' do

      before do
        job.update_attributes(work_status_event: 'start')
      end

      it 'start event is associated with the job' do
        job.events.map(&:class).should =~ [ServiceCallStartedEvent, ServiceCallTransferEvent]
      end

      it 'the job should have'

      it 'the job status should be transferred' do
        expect(job).to be_transferred
      end

      it 'job work status should be in progress' do
        expect(job).to be_work_in_progress
      end

      it 'job payment status should be pending' do
        expect(job).to be_payment_pending
      end

      it 'job available status events should be cancel abd cancel_transfer' do
        job.status_events.should =~ [:cancel, :cancel_transfer]
      end

      it 'job available work events are complete' do
        expect(job.reload.work_status_events).to eq [:complete]
        expect(event_permitted_for_job?('work_status', 'complete', org_admin, job)).to be_true
      end

      it 'the provider and subcontractor should be allowed to collect a payment' do
        expect(job.billing_status_events).to eq [:collect, :subcon_collected]
      end

      it 'subcon status should be pending' do
        expect(job.subcontractor_status_name).to eq :pending
      end

      it 'should have no job available subcon events' do
        expect(job.subcontractor_status_events).to eq []
      end


      context 'when canceled' do
        include_context 'when the provider cancels the job'
        it_should_behave_like 'provider job is canceled'
      end

      context 'when the job is completed' do

        before do
          add_bom_to_job job, price: 100, cost: 10, quantity: 1
          job.update_attributes(work_status_event: 'complete')
        end

        it 'the job status should be transferred' do
          expect(job).to be_transferred
        end

        it 'job work status should be done' do
          expect(job).to be_work_done
        end

        it 'job payment status should be pending' do
          expect(job).to be_payment_pending
        end

        it 'job available status events should be cancel abd cancel_transfer' do
          job.status_events.should =~ [:cancel]
        end

        it 'there are no available work status events for job' do
          expect(job.work_status_events).to be_empty
        end

        it 'job available payment events are: invoice, invoiced by subcon, collect and subcon_collected' do
          expect(job.reload.billing_status_events).to eq [:invoice, :subcon_invoiced, :collect, :subcon_collected]
          expect(event_permitted_for_job?('billing_status', 'invoice', org_admin, job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'subcon_invoiced', org_admin, job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'subcon_collected', org_admin, job)).to be_true
        end

        it 'subcon status should be pending' do
          expect(job.subcontractor_status_name).to eq :pending
        end

        it 'job subcon events should be: settle' do
          expect(job.subcontractor_status_events).to eq [:settle]
          expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
        end

        context 'when canceled' do
          include_context 'when the provider cancels the job'
          it_should_behave_like 'provider job is canceled'
          it_should_behave_like 'provider job canceled after completion'
        end

        context 'when subcon invoices' do
          before do
            job.update_attributes(billing_status_event: 'subcon_invoiced')
          end

          it 'the job status should be transferred' do
            expect(job).to be_transferred
          end

          it 'job work status should be completed' do
            expect(job).to be_work_done
          end

          it 'job payment status should be invoiced by subcon' do
            expect(job).to be_payment_invoiced_by_subcon
          end

          it 'there are no available work status events for job' do
            expect(job.work_status_events).to be_empty
          end

          it 'job available payment events are overdue, collect and collected by subcon' do
            expect(job.billing_status_events).to eq [:overdue, :collect, :subcon_collected]
            expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'subcon_collected', org_admin, job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'overdue', org_admin, job)).to be_true
          end

          it 'subcon status should be pending' do
            expect(job.subcontractor_status_name).to eq :pending
          end

          it 'should have no job available subcon events' do
            expect(job.subcontractor_status_events).to eq [:settle]
          end

          context 'when canceled' do
            include_context 'when the provider cancels the job'
            it_should_behave_like 'provider job is canceled'
            it_should_behave_like 'provider job canceled after completion'
          end

          context 'when prov collects' do

            describe 'for a multi user organization' do

              describe 'collecting payment' do
                describe 'collecting full payment' do

                  let(:collection_job) { job }
                  let(:collector) { job.organization.users.last }
                  let(:billing_status) { :collected_by_employee }        # since the job is not done it is set to partial
                  let(:billing_status_events) { [:deposited] }
                  let(:billing_status_4_cash) { :collected_by_employee } # since the job is not done it is set to partial
                  let(:billing_status_events_4_cash) { [:deposited] }
                  let(:customer_balance_before_payment) { 100 }
                  let(:payment_amount) { 100 }
                  let(:job_events) { [ServiceCallTransferEvent,
                                      ServiceCallStartedEvent,
                                      ServiceCallCompleteEvent,
                                      ServiceCallInvoicedEvent,
                                      ScCollectedByEmployeeEvent] }

                  include_examples 'successful customer payment collection', 'collect'

                  context 'after full collection' do
                    before do
                      job.update_attributes(billing_status_event: 'collect',
                                            payment_type:         'cash',
                                            payment_amount:       payment_amount.to_s,
                                            collector:            collector)
                    end

                    it 'subcon status should be pending' do
                      expect(job.subcontractor_status_name).to eq :pending
                    end

                    it 'job available subcon events are settle' do
                      expect(job.subcontractor_status_events).to eq [:settle]
                      expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    end
                  end

                end

                describe 'collecting partial payment' do
                  include_examples 'successful customer payment collection', 'collect' do
                    let(:collection_job) { job }
                    let(:collector) { job.organization.users.last }
                    let(:billing_status) { :partial_payment_collected_by_employee } # since the job is not done it is set to partial
                    let(:billing_status_events) { [:collect, :deposited] }
                    let(:billing_status_4_cash) { :partial_payment_collected_by_employee }
                    let(:billing_status_events_4_cash) { [:collect, :deposited] }

                    let(:customer_balance_before_payment) { 100 }
                    let(:payment_amount) { 10 }
                    let(:job_events) { [ServiceCallTransferEvent,
                                        ServiceCallStartedEvent,
                                        ServiceCallCompleteEvent,
                                        ServiceCallInvoicedEvent,
                                        ScCollectedByEmployeeEvent] }

                  end
                  context 'after partial collection' do
                    before do
                      job.update_attributes(billing_status_event: 'collect',
                                            payment_type:         'cash',
                                            payment_amount:       payment_amount.to_s,
                                            collector:            collector)
                    end

                    it 'subcon status should be pending' do
                      expect(job.subcontractor_status_name).to eq :pending
                    end

                    it 'job available subcon events are settle' do
                      expect(job.subcontractor_status_events).to eq [:settle]
                      expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    end


                  end

                end

              end

            end

            describe 'for a single user organization' do
              before do
                job.organization.users.map { |user| user.destroy unless user == org_admin }
                job.organization.reload
              end

              describe 'collecting payment' do

                describe 'collecting full payment' do
                  let(:collection_job) { job }
                  let(:collector) { job.organization }
                  let(:billing_status) { :paid }           # since the job is not done it is set to partial
                  let(:billing_status_events) { [:clear, :reject] }
                  let(:billing_status_4_cash) { :cleared } # since the job is not done it is set to partial
                  let(:billing_status_events_4_cash) { [] }
                  let(:customer_balance_before_payment) { 100 }
                  let(:payment_amount) { 100 }
                  let(:job_events) { [ServiceCallTransferEvent,
                                      ServiceCallStartedEvent,
                                      ServiceCallCompleteEvent,
                                      ServiceCallInvoicedEvent,
                                      ServiceCallPaidEvent] }

                  include_examples 'successful customer payment collection', 'paid'

                  context 'after full collection' do
                    before do
                      job.update_attributes(billing_status_event: 'paid',
                                            payment_type:         'cash',
                                            payment_amount:       payment_amount.to_s,
                                            collector:            collector)
                    end

                    it 'job available subcon events are settle' do
                      expect(job.subcontractor_status_events).to eq [:settle]
                      expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    end

                    it 'billing status should be cleared' do
                      expect(job.billing_status_name).to eq :cleared
                    end

                    context 'when cash settled with the subcon' do
                      before do
                        job.update_attributes(subcontractor_status_event: 'settle', subcon_payment: 'cash')
                      end

                      it 'the job status should be transferred' do
                        expect(job).to be_transferred
                      end

                      it 'the available status events for job are cancel and close' do
                        expect(job.status_events).to eq [:cancel, :close]
                        expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                        expect(event_permitted_for_job?('status', 'close', org_admin, job)).to be_true
                      end

                      it 'job work status should be completed' do
                        expect(job).to be_work_done
                      end

                      it 'job payment status should be cleared' do
                        expect(job.billing_status_name).to eq :cleared
                      end

                      it 'there are no available work status events for job' do
                        expect(job.work_status_events).to be_empty
                      end

                      it 'job available payment events are deposited' do
                        expect(job.billing_status_events).to be_empty
                      end

                      it 'subcon status should be cleared' do
                        expect(job.subcontractor_status_name).to eq :cleared
                      end

                      it 'there are no available subcon events' do
                        expect(job.subcontractor_status_events).to eq []
                      end

                    end

                    context 'when none cash settled with the subcon' do
                      before do
                        job.update_attributes(subcontractor_status_event: 'settle', subcon_payment: 'credit_card')
                      end

                      it 'the job status should be transferred' do
                        expect(job).to be_transferred
                      end

                      it 'job work status should be completed' do
                        expect(job).to be_work_done
                      end

                      it 'job payment status should be cleared' do
                        expect(job.billing_status_name).to eq :cleared
                      end

                      it 'there are no available work status events for job' do
                        expect(job.work_status_events).to eq []
                      end

                      it 'job available payment events are deposited' do
                        expect(job.billing_status_events).to eq []
                      end

                      it 'subcon status should be settled' do
                        expect(job.subcontractor_status_name).to eq :settled
                      end

                      it 'available subcon events are clear' do
                        expect(job.subcontractor_status_events).to eq [:clear]
                        expect(event_permitted_for_job?('subcontractor_status', 'clear', org_admin, job)).to be_true
                      end

                      context 'when clearing the subcon payment' do

                        before do
                          job.update_attributes(subcontractor_status_event: 'clear')
                        end

                        it 'the job status should be transferred' do
                          expect(job).to be_transferred
                        end

                        it 'job work status should be completed' do
                          expect(job).to be_work_done
                        end

                        it 'job payment status should be cleared' do
                          expect(job.billing_status_name).to eq :cleared
                        end

                        it 'there are no available work status events for job' do
                          expect(job.work_status_events).to eq []
                        end

                        it 'job available payment events are deposited' do
                          expect(job.billing_status_events).to eq []
                        end

                        it 'subcon status should be settled' do
                          expect(job.subcontractor_status_name).to eq :cleared
                        end

                        it 'there are no available subcon events' do
                          expect(job.subcontractor_status_events).to eq []
                        end
                      end

                      pending 'implement subcon settlement rejection and overdue'

                    end

                  end

                end

                describe 'collecting partial payment' do
                  include_examples 'successful customer payment collection', 'paid' do
                    let(:collection_job) { job }
                    let(:collector) { job.organization.users.last }
                    let(:billing_status) { :partially_paid }        # since the job is not done it is set to partial
                    let(:billing_status_events) { [:clear, :overdue, :paid, :reject] }
                    let(:billing_status_4_cash) { :partially_paid } # since the job is not done it is set to partial
                    let(:billing_status_events_4_cash) { [:paid, :overdue] }
                    let(:customer_balance_before_payment) { 100 }
                    let(:payment_amount) { 10 }
                    let(:job_events) { [ServiceCallTransferEvent,
                                        ServiceCallStartedEvent,
                                        ServiceCallCompleteEvent,
                                        ServiceCallInvoicedEvent,
                                        ServiceCallPaidEvent] }

                  end
                  context 'after partial collection' do
                    before do
                      job.update_attributes(billing_status_event: 'paid',
                                            payment_type:         'cheque',
                                            payment_amount:       payment_amount.to_s,
                                            collector:            collector)
                    end

                    it 'job available subcon events are settle' do
                      expect(job.subcontractor_status_events).to eq [:settle]
                      expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    end

                    it 'clear and reject are not allowed for the user' do
                      expect(event_permitted_for_job?('billing_status', 'clear', org_admin, job)).to be_false
                      expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                    end


                  end

                end

              end

              it 'subcon status should be pending' do
                expect(job.subcontractor_status_name).to eq :pending
              end

              it 'job available subcon events are settle' do
                expect(job.subcontractor_status_events).to eq [:settle]
                expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
              end

            end

          end

          context 'when prov collects none cash' do

            describe 'for a multi user organization' do
              before do
                with_user(org_admin) do
                  job.update_attributes(billing_status_event: 'collect',
                                        payment_type:         'credit_card',
                                        collector:            org_admin,
                                        payment_amount:       '100')

                end
              end

              it 'the available status events for job are: cancel' do
                expect(job.status_events).to eq [:cancel]
                expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
              end

              it 'the job status should be transferred' do
                expect(job).to be_transferred
              end

              it 'job work status should be completed' do
                expect(job).to be_work_done
              end

              it 'job payment status should be collected by employee' do
                expect(job.billing_status_name).to eq :collected_by_employee
              end

              it 'there are no available work status events for job' do
                expect(job.work_status_events).to eq []
              end

              it 'job available payment events are deposited' do
                expect(job.billing_status_events).to eq [:deposited]
                expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_true
              end

              it 'subcon status should be pending' do
                expect(job.subcontractor_status_name).to eq :pending
              end

              it 'job available subcon events are settle' do
                expect(job.subcontractor_status_events).to eq [:settle]
                expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
              end

              describe 'billing' do

                describe 'customer billing' do
                  before { job.customer.account.reload }
                  let(:customer_entry) { job.payments.order('ID ASC').last }

                  it 'entry should have the organization as the collector' do
                    expect(customer_entry.collector).to eq org_admin
                  end

                  it 'entry status should be pending' do
                    expect(customer_entry.status_name).to eq :pending
                  end

                  it 'customer balance should be zero' do
                    expect(job.customer.account.balance).to eq Money.new(0, 'USD')
                  end
                end
              end


              context 'when deposited' do

                before do
                  job.update_attributes(billing_status_event: 'deposited')
                end

                it 'the available status events for job are: cancel' do
                  expect(job.status_events).to eq [:cancel]
                  expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                end

                it 'the job status should be transferred' do
                  expect(job).to be_transferred
                end

                it 'job work status should be completed' do
                  expect(job).to be_work_done
                end

                it 'job payment status should be paid' do
                  expect(job.billing_status_name).to eq :paid
                end

                it 'there are no available work status events for job' do
                  expect(job.work_status_events).to eq []
                end

                it 'job available payment events are deposited' do
                  expect(job.billing_status_events).to eq [:clear, :reject]
                  expect(event_permitted_for_job?('billing_status', 'clear', org_admin, job)).to be_false
                  expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                end

                it 'subcon status should be pending' do
                  expect(job.subcontractor_status_name).to eq :pending
                end

                it 'job available subcon events are settle' do
                  expect(job.subcontractor_status_events).to eq [:settle]
                  expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                end

              end

            end

            describe 'for a single user organization' do
              before do
                job.organization.users.map { |user| user.destroy unless user == org_admin }
                job.organization.reload
                job.update_attributes(billing_status_event: 'paid', payment_type: 'cheque', payment_amount: '100')
              end

              it 'the job status should be transferred' do
                expect(job).to be_transferred
              end

              it 'the available status events for job are: cancel' do
                expect(job.status_events).to eq [:cancel]
                expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
              end

              it 'job work status should be completed' do
                expect(job).to be_work_done
              end

              it 'job payment status should be paid' do
                expect(job.billing_status_name).to eq :paid
              end

              it 'there are no available work status events for job' do
                expect(job.work_status_events).to be_empty
              end

              it 'job available payment events are deposited' do
                expect(job.billing_status_events).to eq [:clear, :reject]
                expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_true
              end

              it 'subcon status should be pending' do
                expect(job.subcontractor_status_name).to eq :pending
              end

              it 'job available subcon events are settle' do
                expect(job.subcontractor_status_events).to eq [:settle]
                expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
              end

              describe 'billing' do

                describe 'customer billing' do
                  before { job.customer.account.reload }
                  let(:customer_entry) { job.payments.order('ID ASC').last }

                  it 'entry should have the organization as the collector' do
                    expect(customer_entry.collector).to eq org
                  end

                  it 'entry status should be pending' do
                    expect(customer_entry.status_name).to eq :pending
                  end


                  it 'customer balance should be zero' do
                    expect(job.customer.account.balance).to eq Money.new(0, 'USD')
                  end
                end
              end

              context 'when cash settled with the subcon' do
                before do
                  job.update_attributes(subcontractor_status_event: 'settle', subcon_payment: 'cash')
                end

                it 'the job status should be transferred' do
                  expect(job).to be_transferred
                end

                it 'the available status events for job are cancel and close' do
                  expect(job.status_events).to eq [:cancel]
                  expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
                end

                it 'job work status should be completed' do
                  expect(job).to be_work_done
                end

                it 'job payment status should be paid' do
                  expect(job.billing_status_name).to eq :paid
                end

                it 'there are no available work status events for job' do
                  expect(job.work_status_events).to be_empty
                end

                it 'job available payment events are clear and reject' do
                  expect(job.billing_status_events).to eq [:clear, :reject]
                end

                it 'subcon status should be cleared' do
                  expect(job.subcontractor_status_name).to eq :cleared
                end

                it 'there are no available subcon events' do
                  expect(job.subcontractor_status_events).to eq []
                end

              end

              context 'when none cash settled with the subcon' do
                before do
                  job.update_attributes(subcontractor_status_event: 'settle', subcon_payment: 'credit_card')
                end

                it 'the job status should be transferred' do
                  expect(job).to be_transferred
                end

                it 'job work status should be completed' do
                  expect(job).to be_work_done
                end

                it 'job payment status should be paid' do
                  expect(job.billing_status_name).to eq :paid
                end

                it 'there are no available work status events for job' do
                  expect(job.work_status_events).to eq []
                end

                it 'job available payment events are deposited' do
                  expect(job.billing_status_events).to eq [:clear, :reject]
                end

                it 'subcon status should be settled' do
                  expect(job.subcontractor_status_name).to eq :settled
                end

                it 'available subcon events are clear' do
                  expect(job.subcontractor_status_events).to eq [:clear]
                  expect(event_permitted_for_job?('subcontractor_status', 'clear', org_admin, job)).to be_true
                end

                context 'when clearing the subcon payment' do

                  before do
                    job.update_attributes(subcontractor_status_event: 'clear')
                  end

                  it 'the job status should be transferred' do
                    expect(job).to be_transferred
                  end

                  it 'job work status should be completed' do
                    expect(job).to be_work_done
                  end

                  it 'job payment status should be paid' do
                    expect(job.billing_status_name).to eq :paid
                  end

                  it 'there are no available work status events for job' do
                    expect(job.work_status_events).to eq []
                  end

                  it 'job available payment events are deposited' do
                    expect(job.billing_status_events).to eq [:clear, :reject]
                  end

                  it 'subcon status should be settled' do
                    expect(job.subcontractor_status_name).to eq :cleared
                  end

                  it 'there are no available subcon events' do
                    expect(job.subcontractor_status_events).to eq []
                  end
                end

                pending 'implement subcon settlement rejection and overdue'

              end

            end

          end

          context 'when subcon collects' do

            describe 'collecting payment' do

              describe 'collecting full payment' do
                let(:collection_job) { job }
                let(:collector) { job.subcontractor.becomes(Organization) }
                let(:billing_status) { :collected_by_subcon }
                let(:billing_status_events) { [:subcon_deposited] }
                let(:billing_status_4_cash) { :collected_by_subcon } # since the job is not done it is set to partial
                let(:billing_status_events_4_cash) { [:subcon_deposited] }
                let(:customer_balance_before_payment) { 100 }
                let(:payment_amount) { 100 }
                let(:job_events) { [ServiceCallTransferEvent,
                                    ServiceCallStartedEvent,
                                    ServiceCallCompleteEvent,
                                    ServiceCallInvoicedEvent,
                                    ScCollectedEvent] }

                include_examples 'successful customer payment collection', 'subcon_collected'

                context 'after full cash collection' do
                  before do
                    job.update_attributes(billing_status_event: 'subcon_collected',
                                          payment_type:         'cash',
                                          payment_amount:       payment_amount.to_s,
                                          collector:            collector)
                  end

                  it 'job available subcon events are settle' do
                    expect(job.subcontractor_status_events).to eq [:settle]
                    expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                  end

                  it 'billing status should be cleared' do
                    expect(job.billing_status_name).to eq :collected_by_subcon
                  end

                  context 'when marking payment as deposited by the subcon' do
                    before do
                      job.update_attributes(billing_status_event: 'subcon_deposited')
                    end

                    it 'billing status should be subcon_claim_deposited' do
                      expect(job.billing_status_name).to eq :subcon_claim_deposited
                    end

                    it 'payment status should be subcon claim deposited' do
                      expect(job.billing_status_name).to eq :subcon_claim_deposited
                    end

                    context 'when confirming the deposit' do
                      before do
                        job.update_attributes(billing_status_event: 'confirm_deposit')
                      end

                      it 'a cheque payment reimbursement exists with the amount derived from the payment' do
                        entry = ReimbursementForCashPayment.find_by_ticket_id(job.id)
                        expect(entry).to_not be_nil
                        expect(entry.amount).to eq Money.new(100)
                      end
                    end


                    context 'when confirming the deposit' do
                      before do
                        job.update_attributes(billing_status_event: 'confirm_deposit')
                      end

                      it 'billing status should be cleared' do
                        expect(job.billing_status_name).to eq :cleared
                      end

                    end

                  end
                end
                context 'after full amex collection' do
                  before do
                    job.update_attributes(billing_status_event: 'subcon_collected',
                                          payment_type:         'amex_credit_card',
                                          payment_amount:       payment_amount.to_s,
                                          collector:            collector)
                  end

                  it 'job available subcon events are settle' do
                    expect(job.subcontractor_status_events).to eq [:settle]
                    expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                  end

                  it 'billing status should be cleared' do
                    expect(job.billing_status_name).to eq :collected_by_subcon
                  end

                  context 'when marking payment as deposited by the subcon' do
                    before do
                      job.update_attributes(billing_status_event: 'subcon_deposited')
                    end

                    it 'billing status should be subcon_claim_deposited' do
                      expect(job.billing_status_name).to eq :subcon_claim_deposited
                    end


                    context 'when confirming the deposit' do
                      before do
                        job.update_attributes(billing_status_event: 'confirm_deposit')
                      end

                      it 'billing status should be cleared' do
                        expect(job.billing_status_name).to eq :paid
                      end

                      context 'when marking the entry as cleared' do
                        let(:customer_entry) { job.payments.order('ID ASC').last }
                        before do
                          customer_entry.update_attributes(status_event: 'clear')
                          job.reload
                        end

                        it 'job billing status should be cleared' do
                          expect(job.billing_status_name).to eq :cleared
                        end
                      end

                    end

                  end
                end


              end

              describe 'collecting partial payment' do

                include_examples 'successful customer payment collection', 'subcon_collected' do
                  let(:collection_job) { job }
                  let(:collector) { job.subcontractor.becomes(Organization) }
                  let(:billing_status) { :partial_payment_collected_by_subcon }
                  let(:billing_status_events) { [:subcon_collected, :subcon_deposited] }
                  let(:billing_status_4_cash) { :partial_payment_collected_by_subcon }
                  let(:billing_status_events_4_cash) { [:subcon_collected, :subcon_deposited] }
                  let(:customer_balance_before_payment) { 100 }
                  let(:payment_amount) { 10 }
                  let(:job_events) { [ServiceCallTransferEvent,
                                      ServiceCallStartedEvent,
                                      ServiceCallCompleteEvent,
                                      ServiceCallInvoicedEvent,
                                      ScCollectedEvent] }

                end
                context 'after partial collection' do

                  context 'when using a cheque' do
                    before do
                      job.update_attributes(billing_status_event: 'subcon_collected',
                                            payment_type:         'cheque',
                                            payment_amount:       payment_amount.to_s,
                                            collector:            collector)
                    end

                    it 'job available subcon events are settle' do
                      expect(job.subcontractor_status_events).to eq [:settle]
                      expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    end

                    it 'clear and reject are not allowed for the user' do
                      expect(event_permitted_for_job?('billing_status', 'clear', org_admin, job)).to be_false
                      expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                    end

                    it 'a cheque payment reimbursement exists with the amount derived from the payment' do
                      entry = ReimbursementForChequePayment.find_by_ticket_id(job.id)
                      expect(entry).to_not be_nil
                      expect(entry.amount).to eq Money.new(10)
                    end

                  end

                  context 'when using cash' do

                    context 'when collecting partial amount' do

                      describe 'when collecting cash' do
                        before do
                          job.update_attributes(billing_status_event: 'subcon_collected',
                                                payment_type:         'cash',
                                                payment_amount:       '10',
                                                collector:            job.subcontractor)
                        end

                        it 'job payment status should be partial_payment_collected_by_subcon' do
                          expect(job.billing_status_name).to eq :partial_payment_collected_by_subcon
                        end

                        it 'available payment events should be subcon deposited and subcon collected' do
                          expect(job.billing_status_events).to eq [:subcon_collected, :subcon_deposited]
                        end

                        context 'when the depositing the amount to the provider' do
                          before do
                            job.update_attributes(billing_status_event: 'subcon_deposited')
                          end

                          it 'payment status should be subcon claim deposited' do
                            expect(job.billing_status_name).to eq :subcon_claim_deposited
                          end

                          context 'when confirming the deposit' do
                            before do
                              job.update_attributes(billing_status_event: 'confirm_deposit')
                            end

                            it 'payment status should be partially paid' do
                              expect(job.billing_status_name).to eq :partially_paid
                            end

                            it 'a cash payment reimbursement exists with the amount derived from the payment' do
                              entry = ReimbursementForCashPayment.find_by_ticket_id(job.id)
                              expect(entry).to_not be_nil
                              expect(entry.amount).to eq Money.new(10)
                            end
                          end
                        end
                      end
                      describe 'when collecting credit card' do
                        before do
                          job.update_attributes(billing_status_event: 'subcon_collected',
                                                payment_type:         'credit_card',
                                                payment_amount:       '10',
                                                collector:            job.subcontractor)
                        end

                        it 'job payment status should be partial_payment_collected_by_subcon' do
                          expect(job.billing_status_name).to eq :partial_payment_collected_by_subcon
                        end

                        it 'available payment events should be subcon deposited and subcon collected' do
                          expect(job.billing_status_events).to eq [:subcon_collected, :subcon_deposited]
                        end

                        context 'when the depositing the amount to the provider' do
                          before do
                            job.update_attributes(billing_status_event: 'subcon_deposited')
                          end

                          it 'payment status should be subcon claim deposited' do
                            expect(job.billing_status_name).to eq :subcon_claim_deposited
                          end

                          context 'when confirming the deposit' do
                            before do
                              job.update_attributes(billing_status_event: 'confirm_deposit')
                            end

                            it 'payment status should be partially paid' do
                              expect(job.billing_status_name).to eq :partially_paid
                            end

                            it 'a cash payment reimbursement exists with the amount derived from the payment' do
                              entry = ReimbursementForCreditPayment.find_by_ticket_id(job.id)
                              expect(entry).to_not be_nil
                              expect(entry.amount).to eq Money.new(10)
                            end
                          end
                        end
                      end
                      describe 'when collecting amex' do

                        before do
                          job.update_attributes(billing_status_event: 'subcon_collected',
                                                payment_type:         'amex_credit_card',
                                                payment_amount:       '10',
                                                collector:            job.subcontractor)
                        end

                        it 'job payment status should be partial_payment_collected_by_subcon' do
                          expect(job.billing_status_name).to eq :partial_payment_collected_by_subcon
                        end

                        it 'available payment events should be subcon deposited and subcon collected' do
                          expect(job.billing_status_events).to eq [:subcon_collected, :subcon_deposited]
                        end

                        context 'when the depositing the amount to the provider' do
                          before do
                            job.update_attributes(billing_status_event: 'subcon_deposited')
                          end

                          it 'payment status should be subcon claim deposited' do
                            expect(job.billing_status_name).to eq :subcon_claim_deposited
                          end

                          context 'when confirming the deposit' do
                            before do
                              job.update_attributes(billing_status_event: 'confirm_deposit')
                            end

                            it 'payment status should be partially paid' do
                              expect(job.billing_status_name).to eq :partially_paid
                            end

                            it 'an amex payment reimbursement exists with the amount derived from the payment' do
                              entry = ReimbursementForAmexPayment.find_by_ticket_id(job.id)
                              expect(entry).to_not be_nil
                              expect(entry.amount).to eq Money.new(10)
                            end
                          end
                        end
                      end
                      describe 'when collecting cheque' do

                        before do
                          job.update_attributes(billing_status_event: 'subcon_collected',
                                                payment_type:         'cheque',
                                                payment_amount:       '10',
                                                collector:            job.subcontractor)
                        end

                        it 'job payment status should be partial_payment_collected_by_subcon' do
                          expect(job.billing_status_name).to eq :partial_payment_collected_by_subcon
                        end

                        it 'available payment events should be subcon deposited and subcon collected' do
                          expect(job.billing_status_events).to eq [:subcon_collected, :subcon_deposited]
                        end

                        context 'when the depositing the amount to the provider' do
                          before do
                            job.update_attributes(billing_status_event: 'subcon_deposited')
                          end

                          it 'payment status should be subcon claim deposited' do
                            expect(job.billing_status_name).to eq :subcon_claim_deposited
                          end

                          context 'when confirming the deposit' do
                            before do
                              job.update_attributes(billing_status_event: 'confirm_deposit')
                            end

                            it 'payment status should be partially paid' do
                              expect(job.billing_status_name).to eq :partially_paid
                            end

                            it 'a cheque payment reimbursement exists with the amount derived from the payment' do
                              entry = ReimbursementForChequePayment.find_by_ticket_id(job.id)
                              expect(entry).to_not be_nil
                              expect(entry.amount).to eq Money.new(10)
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

          context 'when payment is overdue' do
            pending
          end

        end

        context 'when the prov invoices' do
          pending
        end


      end


    end

  end

end