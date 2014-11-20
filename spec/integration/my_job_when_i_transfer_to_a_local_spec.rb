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
    expect(job.billing_status_events).to eq [:late, :collect]
    expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
  end

  it 'subcon status should be pending' do
    expect(job.subcontractor_status_name).to eq :pending
  end

  it 'should have no job available subcon events' do
    expect(job.subcontractor_status_events).to eq [:cancel]
  end

  describe 'partial collection' do
    pending
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
      expect(job.reload.work_status_events).to eq [:start, :reset, :cancel]
      expect(event_permitted_for_job?('work_status', 'start', org_admin, job)).to be_true
    end

    it 'the available payment events for the job are collect and subcon collected' do
      expect(job.billing_status_events).to eq [:late, :collect]
      expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
    end

    it 'subcon status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'should have no job available subcon events' do
      expect(job.subcontractor_status_events).to eq [:cancel]
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
        expect(job.reload.work_status_events).to eq [:reset, :complete, :cancel]
        expect(event_permitted_for_job?('work_status', 'complete', org_admin, job)).to be_true
      end

      it 'late and collect are the only billing actions available' do
        expect(job.billing_status_events).to eq [:late, :collect]
      end

      it 'subcon status should be pending' do
        expect(job.subcontractor_status_name).to eq :pending
      end

      it 'should have no job available subcon events' do
        expect(job.subcontractor_status_events).to eq [:cancel]
      end

      context 'when the job is completed' do

        before do
          add_bom_to_job job, price: 100, cost: 10, quantity: 1, buyer: job.subcontractor
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
          job.status_events.should eq []
        end

        it 'there are no available work status events for job' do
          expect(job.work_status_events).to be_empty
        end

        it 'job available payment events are: late and collect' do
          expect(job.reload.billing_status_events).to eq [:late, :collect]
          expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'late', org_admin, job)).to be_true
        end

        it 'subcon status should be pending' do
          expect(job.subcontractor_status_name).to eq :pending
        end

        it 'job subcon events should be: settle' do
          expect(job.subcontractor_status_events).to eq [:settle, :cancel]
          expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
          expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
        end

        it 'balance should be updated with payment to subcon' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000)
        end



        it 'the job status should be transferred' do
          expect(job).to be_transferred
        end

        it 'job work status should be completed' do
          expect(job).to be_work_done
        end

        it 'there are no available work status events for job' do
          expect(job.work_status_events).to be_empty
        end

        it 'job available payment events are late and collect' do
          expect(job.billing_status_events).to eq [:late, :collect]
          expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'late', org_admin, job)).to be_true
        end

        it 'subcon status should be pending' do
          expect(job.subcontractor_status_name).to eq :pending
        end

        it 'should have no job available subcon events' do
          expect(job.subcontractor_status_events).to eq [:settle, :cancel]
        end

        context 'when prov collects' do

          describe 'for a multi user organization' do

            describe 'collecting payment' do
              describe 'collecting full payment' do

                let(:collection_job) { job }
                let(:collector) { job.organization.users.last }
                let(:billing_status) { :collected }                    # since the job is not done it is set to partial
                let(:billing_status_events) { [:deposited] }
                let(:billing_status_4_cash) { :collected } # since the job is not done it is set to partial
                let(:billing_status_events_4_cash) { [:deposited] }
                let(:customer_balance_before_payment) { 100 }
                let(:payment_amount) { 100 }
                let(:job_events) { [ServiceCallTransferEvent,
                                    ServiceCallStartedEvent,
                                    ServiceCallCompleteEvent,
                                    ScCollectEvent] }
                let(:subcon_collection_status_4_cash) { :pending }
                let(:prov_collection_status_4_cash) { nil }
                let(:subcon_collection_status) { :pending }
                let(:prov_collection_status) { nil }
                let(:the_prov_job) { nil }

                include_examples 'successful customer payment collection', 'collect'

                context 'after full collection' do
                  before do
                    job.update_attributes(billing_status_event: 'collect',
                                          payment_type:         'cash',
                                          payment_amount:       payment_amount.to_s,
                                          collector:            collector)
                  end

                  it 'balance should be updated with the cash payment fee only as the contractor collected the payment' do
                    expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000 + 10000*0.01)
                  end


                  it 'subcon status should be pending' do
                    expect(job.subcontractor_status_name).to eq :pending
                  end

                  it 'job available subcon events are settle' do
                    expect(job.subcontractor_status_events).to eq [:settle, :cancel]
                    expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
                  end
                end

              end

              describe 'collecting partial payment' do
                include_examples 'successful customer payment collection', 'collect' do
                  let(:collection_job) { job }
                  let(:collector) { job.organization.users.last }
                  let(:billing_status) { :partially_collected } # since the job is not done it is set to partial
                  let(:billing_status_events) { [:collect, :deposited] }
                  let(:billing_status_4_cash) { :partially_collected }
                  let(:billing_status_events_4_cash) { [:collect, :deposited] }

                  let(:customer_balance_before_payment) { 100 }
                  let(:payment_amount) { 10 }
                  let(:job_events) { [ServiceCallTransferEvent,
                                      ServiceCallStartedEvent,
                                      ServiceCallCompleteEvent,
                                      ScCollectEvent
                                      ] }

                  let(:subcon_collection_status_4_cash) { :pending }
                  let(:prov_collection_status_4_cash) { nil }
                  let(:subcon_collection_status) { :pending }
                  let(:prov_collection_status) { nil }
                  let(:the_prov_job) { nil }


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
                    expect(job.subcontractor_status_events).to eq [:settle, :cancel]
                    expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
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
                let(:collector) { job.subcontractor.becomes(Organization) }
                let(:billing_status) { :collected }           # since the job is not done it is set to partial
                let(:billing_status_events) { [:deposit] }
                let(:billing_status_4_cash) { :collected } # since the job is not done it is set to partial
                let(:billing_status_events_4_cash) { [] }
                let(:customer_balance_before_payment) { 100 }
                let(:payment_amount) { 100 }
                let(:job_events) { [ServiceCallTransferEvent,
                                    ServiceCallStartedEvent,
                                    ServiceCallCompleteEvent,
                                    ScCollectEvent] }

                let(:subcon_collection_status_4_cash) { :collected }
                let(:prov_collection_status_4_cash) { nil }
                let(:subcon_collection_status) { :collected }
                let(:prov_collection_status) { nil }
                let(:the_prov_job) { nil }


                include_examples 'successful customer payment collection', 'paid'

                context 'after full collection' do
                  before do
                    collect_full_amount job, type: 'cash', collector: collector
                    job.collected_entries.last.deposited!
                    job.deposited_entries.last.confirm!
                    job.payments.last.deposit!
                    job.reload
                  end

                  it 'job available subcon events are settle' do
                    expect(job.subcontractor_status_events).to eq [:settle, :cancel]
                    expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
                  end

                  it 'billing status should be paid' do
                    expect(job.billing_status_name).to eq :paid
                  end

                  context 'when cash settled with the subcon' do
                    before do
                      job.update_attributes(subcontractor_status_event: 'settle', subcon_payment: 'cash')
                    end

                    it 'the job status should be transferred' do
                      expect(job).to be_transferred
                    end

                    it 'the available status events for job are cancel and close' do
                      expect(job.status_events).to eq [:close]
                      expect(event_permitted_for_job?('status', 'close', org_admin, job)).to be_true
                    end

                    it 'job work status should be completed' do
                      expect(job).to be_work_done
                    end

                    it 'there are no available work status events for job' do
                      expect(job.work_status_events).to be_empty
                    end

                    it 'job available payment events are cancel, but not available to the user' do
                      expect(job.billing_status_events).to eq [:cancel]
                      expect(event_permitted_for_job?('billing_status', 'cancel', org_admin, job)).to be_false
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

                    it 'there are no available work status events for job' do
                      expect(job.work_status_events).to eq []
                    end

                    it 'job available payment events are cancel' do
                      expect(job.billing_status_events).to eq [:cancel]
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

                      it 'there are no available work status events for job' do
                        expect(job.work_status_events).to eq []
                      end

                      it 'job available payment events are cancel' do
                        expect(job.billing_status_events).to eq [:cancel]
                      end

                      it 'subcon status should be cleared' do
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
                  let(:billing_status) { :partially_collected }        # since the job is not done it is set to partial
                  let(:billing_status_events) { [:clear, :overdue, :paid, :reject] }
                  let(:billing_status_4_cash) { :partially_collected } # since the job is not done it is set to partial
                  let(:billing_status_events_4_cash) { [:paid, :overdue] }
                  let(:customer_balance_before_payment) { 100 }
                  let(:payment_amount) { 10 }
                  let(:job_events) { [ServiceCallTransferEvent,
                                      ServiceCallStartedEvent,
                                      ServiceCallCompleteEvent,
                                      ScCollectEvent] }

                  let(:subcon_collection_status_4_cash) { :pending }
                  let(:prov_collection_status_4_cash) { nil }
                  let(:subcon_collection_status) { :pending }
                  let(:prov_collection_status) { nil }
                  let(:the_prov_job) { nil }


                end
                context 'after partial collection' do
                  before do
                    collect_a_payment job, type: 'cheque', collector: collector, amount: 5
                    job.payments.last.deposit!
                    job.reload

                  end

                  it 'job available subcon events are settle and cancel' do
                    expect(job.subcontractor_status_events).to eq [:settle, :cancel]
                    expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
                    expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
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
              expect(job.subcontractor_status_events).to eq [:settle, :cancel]
              expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
              expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
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

            # it 'the available status events for job are: cancel' do
            #   expect(job.status_events).to eq [:cancel]
            #   expect(event_permitted_for_job?('status', 'cancel', org_admin, job)).to be_true
            # end

            it 'the job status should be transferred' do
              expect(job).to be_transferred
            end

            it 'job work status should be completed' do
              expect(job).to be_work_done
            end

            it 'job payment status should be collected by employee' do
              expect(job.billing_status_name).to eq :collected
            end

            it 'there are no available work status events for job' do
              expect(job.work_status_events).to eq []
            end

            it 'job available payment events are deposited' do
              expect(job.billing_status_events).to eq [:deposited]
              expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_false
            end

            it 'subcon status should be pending' do
              expect(job.subcontractor_status_name).to eq :pending
            end

            it 'job available subcon events are settle' do
              expect(job.subcontractor_status_events).to eq [:settle, :cancel]
              expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, job)).to be_true
              expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
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

          end

        end

        context 'when subcon collects' do

          describe 'collecting payment' do

            describe 'collecting full payment' do
              let(:collection_job) { job }
              let(:collector) { job.subcontractor.becomes(Organization) }
              let(:billing_status) { :collected }
              let(:billing_status_events) { [:late, :collect] }
              let(:billing_status_4_cash) { :collected } # since the job is not done it is set to partial
              let(:billing_status_events_4_cash) { [:late, :collect] }
              let(:customer_balance_before_payment) { 100 }
              let(:payment_amount) { 100 }
              let(:job_events) { [ServiceCallTransferEvent,
                                  ServiceCallStartedEvent,
                                  ServiceCallCompleteEvent,
                                  ScCollectEvent] }


              let(:subcon_collection_status_4_cash) { :collected }
              let(:prov_collection_status_4_cash) { nil }
              let(:subcon_collection_status) { :collected }
              let(:prov_collection_status) { nil }
              let(:the_prov_job) { nil }


              include_examples 'successful customer payment collection', 'subcon_collected'

              context 'after full cash collection' do
                before do
                  collect_full_amount job, type: 'cash', collector: collector
                end

                it 'job available subcon events are settle' do
                  expect(job.subcontractor_status_events).to eq [:cancel]
                  expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_false
                end

                it 'billing status should be cleared' do
                  expect(job.billing_status_name).to eq :collected
                end

                it 'deposited is an available billing event but it is not permitted for a user' do
                  expect(job.billing_status_events).to eq [:deposited]
                  expect(event_permitted_for_job?('billing_status', 'deposited', org_admin, job)).to be_false
                end

                context 'when marking payment as deposited by the subcon' do
                  let(:collected_entry) { job.collected_entries.last }
                  let(:deposit_entry) { job.accounting_entries.last }

                  before do
                    collected_entry.deposited!
                  end

                  it 'should change entry status to cleared' do
                    expect(collected_entry.status_name).to eq :deposited
                  end

                  it 'should create a CashDepositFromSubcon entry' do
                    expect(job.reload.accounting_entries.last).to be_instance_of(CashDepositFromSubcon)
                  end

                  it 'billing status should be subcon_claim_deposited' do
                    expect(job.reload.billing_status_name).to eq :collected
                  end

                  it 'billing status should have the deposit event only once' do
                    expect(job.reload.events.map { |e| e.class.name }).to eq ['ScSubconDepositedEvent',
                                                                              'ScCollectEvent',
                                                                              'ServiceCallCompleteEvent',
                                                                              'ServiceCallStartedEvent',
                                                                              'ServiceCallTransferEvent']


                  end

                  it 'affiliate balance should be updated with the deposit' do
                    expect(collected_entry.account.reload.balance).to eq Money.new(-10900)
                  end


                  context 'when deposit confirmed' do

                    before do
                      deposit_entry.confirm!
                    end

                    it 'deposit entry status should be confirmed' do
                      expect(deposit_entry.status_name).to eq :confirmed
                    end

                    it 'payment status should be cleared' do
                      expect(job.reload.billing_status_name).to eq :collected
                    end

                    it 'a cash payment reimbursement exists with the amount derived from the payment' do
                      entry = ReimbursementForCashPayment.find_by_ticket_id(job.id)
                      expect(entry).to_not be_nil
                      expect(entry.amount).to eq Money.new(100)
                    end
                  end

                  context 'when the deposit is disputed' do
                    before do
                      deposit_entry.dispute!
                    end

                    it 'deposit entry status should be confirmed' do
                      expect(deposit_entry.status_name).to eq :disputed
                    end

                    it 'the last event should be EntryDisputedEvent' do
                      expect(job.events.order('ID DESC').first).to be_instance_of(DepositEntryDisputeEvent)
                    end

                    it 'payment status should be collected' do
                      expect(job.reload.billing_status_name).to eq :collected
                    end

                    it 'available entry status events are canceled and confirmed' do
                      expect(deposit_entry.allowed_status_events).to eq [:confirm]
                    end

                    context 'when confirming' do
                      before do
                        deposit_entry.confirm!
                      end

                      it 'deposit entry status should be confirmed' do
                        expect(deposit_entry.status_name).to eq :confirmed
                      end


                    end
                  end

                end
              end
              context 'after full amex collection' do
                before do
                  collect_a_payment job, type: 'cash', collector: collector, type: 'amex_credit_card', amount: payment_amount
                end


                it 'billing status should be collected' do
                  expect(job.billing_status_name).to eq :collected
                end

                it 'balance should be updated' do
                  expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000 + 10000*0.01 + 10000)
                end


                context 'when marking payment as deposited by the subcon' do
                  let(:collected_entry) { job.collected_entries.last }

                  before do
                    collected_entry.deposited!
                  end

                  it 'billing status should be collected and subcon collection is deposited' do
                    expect(job.reload.billing_status_name).to eq :collected
                    expect(job.subcon_collection_status_name).to eq :is_deposited
                  end

                  it 'should change entry status to deposited' do
                    expect(collected_entry.status_name).to eq :deposited
                  end

                  it 'should create a CashDepositFromSubcon entry' do
                    expect(job.reload.accounting_entries.last).to be_instance_of(AmexDepositFromSubcon)
                  end

                  it 'balance should be updated' do
                    expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000 + 10000*0.01)
                  end

                  context 'when confirming the subcon deposit and depositing the payment' do
                    let(:deposit_entry) { job.accounting_entries.last }
                    before do
                      deposit_entry.confirm!
                      job.payments.last.deposit!
                    end

                    it 'deposit entry status should be confirmed' do
                      expect(deposit_entry.status_name).to eq :confirmed
                    end

                    it 'payment status should stay collected' do
                      expect(job.reload.billing_status_name).to eq :in_process
                    end

                    it 'the balance should not change' do
                      # amount is 100 subcon fee, 10 bom reimbursement + 1% cash payment fee
                      expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000 + 10000*0.01)
                    end

                    describe 'customer entry' do

                      it 'customer entry events should be clear and reject' do
                        expect(job.payments.order('ID ASC').last.allowed_status_events).to eq [:clear, :reject]
                      end

                      context 'when marking the entry as cleared' do
                        let(:customer_entry) { job.payments.order('ID ASC').last }
                        before do
                          customer_entry.update_attributes(status_event: 'deposit')
                          customer_entry.update_attributes(status_event: 'clear')
                          job.reload
                        end

                        it 'job billing status should be paid' do
                          expect(job.billing_status_name).to eq :paid
                        end
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
                let(:billing_status) { :partially_collected }
                let(:billing_status_events) { [:collect, :late] }
                let(:billing_status_4_cash) { :partially_collected }
                let(:billing_status_events_4_cash) { [:collect, :late] }
                let(:customer_balance_before_payment) { 100 }
                let(:payment_amount) { 10 }
                let(:job_events) { [ServiceCallTransferEvent,
                                    ServiceCallStartedEvent,
                                    ServiceCallCompleteEvent,
                                    ScCollectEvent] }


                let(:subcon_collection_status_4_cash) { :partially_collected }
                let(:prov_collection_status_4_cash) { nil }
                let(:subcon_collection_status) { :partially_collected }
                let(:prov_collection_status) { nil }
                let(:the_prov_job) { nil }


              end

              context 'after partial collection' do

                context 'when using a cheque' do
                  before do
                     collect_a_payment job, amount: payment_amount, collector: collector, type: 'cheque'
                    job.reload
                  end

                  it 'job available subcon events are settle' do
                    expect(job.subcontractor_status_events).to eq [:cancel]
                    expect(event_permitted_for_job?('subcontractor_status', 'cancel', org_admin, job)).to be_fale
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

                  it 'affiliate balance should be updated with the deposit' do
                    expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000 + 1000 + 1000*0.01)
                  end


                  context 'when marking payment as deposited by the subcon' do
                    let(:collected_entry) { job.collected_entries.last }
                    let(:deposit_entry) { job.accounting_entries.last }

                    before do
                      collected_entry.deposited!
                    end

                    it 'should change entry status to cleared' do
                      expect(collected_entry.status_name).to eq :deposited
                    end

                    it 'should create a CashDepositFromSubcon entry' do
                      expect(job.reload.accounting_entries.last).to be_instance_of(ChequeDepositFromSubcon)
                    end

                    it 'billing status should be partially_collected' do
                      expect(job.reload.billing_status_name).to eq :partially_collected
                    end

                    it 'billing status should have the deposit event only once' do
                      expect(job.reload.events.map { |e| e.class.name }).to eq ['ScSubconDepositedEvent',
                                                                                'ScCollectEvent',
                                                                                'ServiceCallCompleteEvent',
                                                                                'ServiceCallStartedEvent',
                                                                                'ServiceCallTransferEvent']


                    end

                    it 'affiliate balance should be updated with the deposit' do
                      expect(deposit_entry.account.balance).to eq Money.new(-11000 + 1000*0.01)
                    end


                    context 'when deposit confirmed' do

                      before do
                        deposit_entry.confirm!
                      end

                      it 'deposit entry status should be confirmed' do
                        expect(deposit_entry.status_name).to eq :confirmed
                      end

                      it 'payment status should be cleared' do
                        expect(job.reload.billing_status_name).to eq :partially_collected
                      end

                      it 'a cash payment reimbursement exists with the amount derived from the payment' do
                        entry = ReimbursementForChequePayment.find_by_ticket_id(job.id)
                        expect(entry).to_not be_nil
                        expect(entry.amount).to eq Money.new(10)
                      end
                    end

                    context 'when the deposit is disputed' do
                      before do
                        deposit_entry.dispute!
                      end

                      it 'deposit entry status should be confirmed' do
                        expect(deposit_entry.status_name).to eq :disputed
                      end

                      it 'the last event should be EntryDisputedEvent' do
                        expect(job.events.order('ID DESC').first).to be_instance_of(DepositEntryDisputeEvent)
                      end

                      it 'payment status should be partially_collected' do
                        expect(job.reload.billing_status_name).to eq :partially_collected
                      end

                      it 'available entry status events are canceled and confirmed' do
                        expect(deposit_entry.status_events).to eq [:confirm]
                      end

                      context 'when confirming' do
                        before do
                          deposit_entry.confirm!
                        end

                        it 'deposit entry status should be confirmed' do
                          expect(deposit_entry.status_name).to eq :confirmed
                        end

                        it 'payment status should be partially_collected' do
                          expect(job.reload.billing_status_name).to eq :partially_collected
                        end

                      end
                    end

                  end
                end

                context 'when using cash' do

                  context 'when collecting partial amount' do

                    describe 'when collecting cash' do
                      before do
                        collect_a_payment job, amount: payment_amount, type: 'cash', collector: collector
                        job.reload
                      end

                      it 'job payment status should be partially_collected' do
                        expect(job.billing_status_name).to eq :partially_collected
                      end

                      it 'available payment events should be subcon deposited and subcon collected' do
                        expect(job.billing_status_events).to eq [:reject, :late, :collect, :cancel]
                      end

                      context 'when the depositing the amount to the provider' do

                        let(:collected_entry) { job.collected_entries.last }
                        let(:deposit_entry) { job.accounting_entries.last }

                        before do
                          job.collected_entries.last.deposited!
                          job.reload
                        end

                        it 'payment status should be subcon  partially_collected' do
                          expect(job.billing_status_name).to eq :partially_collected
                        end

                        it 'affiliate balance should be updated with the deposit' do
                          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-11000 + 1000*0.01)
                        end



                          it 'should change entry status to cleared' do
                            expect(collected_entry.status_name).to eq :deposited
                          end

                          it 'should create a CashDepositFromSubcon entry' do
                            expect(job.reload.accounting_entries.last).to be_instance_of(CashDepositFromSubcon)
                          end

                          it 'billing status should be partially_collected' do
                            expect(job.reload.billing_status_name).to eq :partially_collected
                          end

                          it 'billing status should have the deposit event only once' do
                            expect(job.reload.events.map { |e| e.class.name }).to eq ['ScSubconDepositedEvent',
                                                                                      'ScCollectEvent',
                                                                                      'ServiceCallCompleteEvent',
                                                                                      'ServiceCallStartedEvent',
                                                                                      'ServiceCallTransferEvent']


                          end

                          it 'affiliate balance should be updated with the deposit' do
                            expect(deposit_entry.account.balance).to eq Money.new(-11000 + 1000*0.01)
                          end


                          context 'when deposit confirmed' do

                            before do
                              deposit_entry.confirm!
                            end

                            it 'deposit entry status should be confirmed' do
                              expect(deposit_entry.status_name).to eq :confirmed
                            end

                            it 'payment status should be partially_collected' do
                              expect(job.reload.billing_status_name).to eq :partially_collected
                            end

                            it 'a cash payment reimbursement exists with the amount derived from the payment' do
                              entry = ReimbursementForCashPayment.find_by_ticket_id(job.id)
                              expect(entry).to_not be_nil
                              expect(entry.amount).to eq Money.new(10)
                            end
                          end

                          context 'when the deposit is disputed' do
                            before do
                              deposit_entry.dispute!
                            end

                            it 'deposit entry status should be confirmed' do
                              expect(deposit_entry.status_name).to eq :disputed
                            end

                            it 'the last event should be EntryDisputedEvent' do
                              expect(job.events.order('ID DESC').first).to be_instance_of(DepositEntryDisputeEvent)
                            end

                            it 'payment status should be partially_collected' do
                              expect(job.reload.billing_status_name).to eq :partially_collected
                            end

                            it 'available entry status events are canceled and confirmed' do
                              expect(deposit_entry.status_events).to eq [:confirm]
                            end

                            context 'when confirming' do
                              before do
                                deposit_entry.confirm!
                              end

                              it 'deposit entry status should be confirmed' do
                                expect(deposit_entry.status_name).to eq :confirmed
                              end

                              it 'payment status should be cleared' do
                                expect(job.reload.billing_status_name).to eq :partially_collected
                              end

                              it 'subcon collection status deposited' do
                                expect(job.reload.subcon_collection_status_name).to eq :deposited
                              end

                            end
                          end


                      end
                    end
                    describe 'when collecting credit card' do
                      before do
                        collect_a_payment job, collector: job.subcontractor, amount: 10, type: 'credit_card'
                      end

                      it 'job payment status should be partially_collected' do
                        expect(job.billing_status_name).to eq :partially_collected
                      end

                      it 'available payment events should be subcon deposited and subcon collected' do
                        expect(job.billing_status_events).to eq [:reject, :late, :collect, :cancel]
                      end

                      context 'when the depositing the amount to the provider' do
                        before do
                          job.collected_entries.last.update_attributes(status_event: 'deposited')
                          #job.update_attributes(billing_status_event: 'subcon_deposited')
                        end


                        context 'when confirming the deposit' do
                          before do
                            job.deposited_entries.last.update_attributes(status_event: 'confirm')
                          end

                          it 'payment status should be partially_collected' do
                            expect(job.billing_status_name).to eq :partially_collected
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
                        collect_a_payment job, type:  'amex_credit_card', collector: job.subcontractor, amount: 10
                      end

                      it 'job payment status should be partially_collected' do
                        expect(job.billing_status_name).to eq :partially_collected
                      end

                      it 'available payment events should be subcon deposited and subcon collected' do
                        expect(job.billing_status_events).to eq [:reject, :late, :collect, :cancel]
                      end

                      context 'when the depositing the amount to the provider' do
                        before do
                          job.update_attributes(billing_status_event: 'subcon_deposited')
                        end

                        it 'payment status should be partially_collected' do
                          expect(job.billing_status_name).to eq :partially_collected
                        end

                        context 'when confirming the deposit' do
                          before do
                            job.update_attributes(billing_status_event: 'confirm_deposit')
                          end

                          it 'payment status should be partially_collected' do
                            expect(job.billing_status_name).to eq :partially_collected
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
                        collect_a_payment job, amount: 10, type: 'cheque', collector: job.subcontractor
                      end

                      it 'job payment status should be partially_collected' do
                        expect(job.billing_status_name).to eq :partially_collected
                      end

                      it 'available payment events should be late and collect' do
                        expect(job.billing_status_events).to eq [:reject, :late, :collect, :cancel]
                      end

                      context 'when the depositing the amount to the provider' do
                        before do
                          job.collected_entries.last.update_attributes(status_event: 'deposited')
                        end

                        context 'when confirming the deposit' do
                          before do
                            job.deposited_entries.last.update_attributes(status_event: 'confirm')
                          end

                          it 'payment status should be partially collected' do
                            expect(job.billing_status_name).to eq :partially_collected
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


        context 'when the prov invoices' do
          pending
        end


      end


    end

  end

end