require 'spec_helper'

shared_examples 'collection before completion' do
  context 'when prov collects' do

    describe 'collecting partial payment' do
      let(:collection_job) { job }
      let(:collector) { job.organization.users.last }
      let(:billing_status) { :partial_payment_collected_by_employee } # since the job is not done it is set to partial
      let(:billing_status_events) { [:collect, :deposited] }
      let(:billing_status_4_cash) { :partial_payment_collected_by_employee }
      let(:billing_status_events_4_cash) { [:deposited, :collect] }

      let(:customer_balance_before_payment) { 0 }
      let(:payment_amount) { 10 }
      let(:job_events) { prov_job_events }

      include_examples 'successful customer payment collection', 'collect'

      it 'subcon job billing events are provider_collected but it is not permitted for a user' do
        expect(subcon_job.reload.billing_status_events).to eq [:provider_collected, :collect]
        expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
        expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
      end

      context 'after partial collection' do

        describe 'cash collection' do
          before do
            job.update_attributes(billing_status_event: 'collect',
                                  payment_type:         'cash',
                                  payment_amount:       payment_amount.to_s,
                                  collector:            collector)
          end

          it 'subcon status should be pending' do
            expect(job.subcontractor_status_name).to eq :pending
          end

          it 'subcon job billing status is partially collected' do
            expect(subcon_job.reload.billing_status_name).to eq :partially_collected
          end

          it 'subcon job has the provider collected event associated' do
            expect(subcon_job.events.map(&:class)).to include(ScProviderCollectedEvent)
          end

          it 'provider and subcon accounts are reconciled' do
            # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
            amount_cents = payment_amount
            expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
            expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
          end
        end

        describe 'credit card collection', focus: true do
          before do
            job.update_attributes(billing_status_event: 'collect',
                                  payment_type:         'credit_card',
                                  payment_amount:       payment_amount.to_s,
                                  collector:            collector)
          end

          it 'subcon status should be pending' do
            expect(job.subcontractor_status_name).to eq :pending
          end

          it 'subcon job billing status is partially collected' do
            expect(subcon_job.reload.billing_status_name).to eq :partially_collected
          end

          it 'subcon job has the provider collected event associated' do
            expect(subcon_job.events.map(&:class)).to include(ScProviderCollectedEvent)
          end

          it 'provider and subcon accounts are reconciled', focus: true do
            # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
            amount_cents = payment_amount
            expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
            expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
          end
        end

        describe 'amex card collection' do
          before do
            job.update_attributes(billing_status_event: 'collect',
                                  payment_type:         'amex_credit_card',
                                  payment_amount:       payment_amount.to_s,
                                  collector:            collector)
          end

          it 'subcon status should be pending' do
            expect(job.subcontractor_status_name).to eq :pending
          end

          it 'subcon job billing status is partially collected' do
            expect(subcon_job.reload.billing_status_name).to eq :partially_collected
          end

          it 'subcon job has the provider collected event associated' do
            expect(subcon_job.events.map(&:class)).to include(ScProviderCollectedEvent)
          end

          it 'provider and subcon accounts are reconciled' do
            # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
            amount_cents = payment_amount
            expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
            expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
          end
        end

        describe 'cheque collection' do
          before do
            job.update_attributes(billing_status_event: 'collect',
                                  payment_type:         'cheque',
                                  payment_amount:       payment_amount.to_s,
                                  collector:            collector)
          end

          it 'subcon status should be pending' do
            expect(job.subcontractor_status_name).to eq :pending
          end

          it 'subcon job billing status is partially collected' do
            expect(subcon_job.reload.billing_status_name).to eq :partially_collected
          end

          it 'subcon job has the provider collected event associated' do
            expect(subcon_job.events.map(&:class)).to include(ScProviderCollectedEvent)
          end

          it 'provider and subcon accounts are reconciled' do
            # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
            amount_cents = payment_amount
            expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
            expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
          end
        end

      end

    end

  end

  context 'when subcon collects' do

    context 'with a single user organization' do

      describe 'collecting partial payment' do
        let(:collection_job) { subcon_job }
        let(:collector) { subcon }
        let(:billing_status) { :partially_collected } # since the job is not done it is set to partial
        let(:billing_status_events) { [:collect, :deposit_to_prov, :provider_collected] }
        let(:billing_status_4_cash) { :partially_collected }
        let(:billing_status_events_4_cash) { [:deposit_to_prov, :provider_collected, :collect] }

        let(:customer_balance_before_payment) { 0 }
        let(:payment_amount) { 10 }
        let(:job_events) { subcon_job_events }

        include_examples 'successful customer payment collection', 'collect'

        it 'subcon job billing events are collect and provider_collected which it is not permitted for a user' do
          expect(subcon_job.reload.billing_status_events).to eq [:provider_collected, :collect]
          expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
          expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
        end

        context 'after partial collection' do

          describe 'cash collection' do
            before do
              subcon_job.update_attributes(billing_status_event: 'collect',
                                           payment_type:         'cash',
                                           payment_amount:       payment_amount.to_s,
                                           collector:            collector)
            end

            it 'subcon status should be pending' do
              expect(subcon_job.provider_status_name).to eq :pending
            end

            it 'provider job billing status is partially collected by subcon' do
              expect(job.reload.billing_status_name).to eq :partial_payment_collected_by_subcon
            end

            it 'subcon job has the provider collected event associated' do
              expect(job.events.map(&:class)).to include(ScCollectedEvent)
            end


            it 'provider and subcon accounts are reconciled' do
              # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
              amount_cents = payment_amount*100 + payment_amount

              expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
              expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
            end
          end
          describe 'credit card collection' do
            before do
              subcon_job.update_attributes(billing_status_event: 'collect',
                                           payment_type:         'credit_card',
                                           payment_amount:       payment_amount.to_s,
                                           collector:            collector)
            end

            it 'subcon status should be pending' do
              expect(subcon_job.provider_status_name).to eq :pending
            end

            it 'provider job billing status is partially collected by subcon' do
              expect(job.reload.billing_status_name).to eq :partial_payment_collected_by_subcon
            end

            it 'subcon job has the provider collected event associated' do
              expect(job.events.map(&:class)).to include(ScCollectedEvent)
            end


            it 'provider and subcon accounts are reconciled' do
              # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
              amount_cents = payment_amount*100 + payment_amount

              expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
              expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
            end
          end

          describe 'amex credit card collection' do
            before do
              subcon_job.update_attributes(billing_status_event: 'collect',
                                           payment_type:         'amex_credit_card',
                                           payment_amount:       payment_amount.to_s,
                                           collector:            collector)
            end

            it 'subcon status should be pending' do
              expect(subcon_job.provider_status_name).to eq :pending
            end

            it 'provider job billing status is partially collected by subcon' do
              expect(job.reload.billing_status_name).to eq :partial_payment_collected_by_subcon
            end

            it 'subcon job has the provider collected event associated' do
              expect(job.events.map(&:class)).to include(ScCollectedEvent)
            end


            it 'provider and subcon accounts are reconciled' do
              # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
              amount_cents = payment_amount*100 + payment_amount

              expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
              expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
            end
          end

          describe 'cheque collection' do
            before do
              subcon_job.update_attributes(billing_status_event: 'collect',
                                           payment_type:         'cheque',
                                           payment_amount:       payment_amount.to_s,
                                           collector:            collector)
            end

            it 'subcon status should be pending' do
              expect(subcon_job.provider_status_name).to eq :pending
            end

            it 'provider job billing status is partially collected by subcon' do
              expect(job.reload.billing_status_name).to eq :partial_payment_collected_by_subcon
            end

            it 'subcon job has the provider collected event associated' do
              expect(job.events.map(&:class)).to include(ScCollectedEvent)
            end


            it 'provider and subcon accounts are reconciled' do
              # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
              amount_cents = payment_amount*100 + payment_amount

              expect(subcon.account_for(org).balance).to eq Money.new(-amount_cents)
              expect(org.account_for(subcon).balance).to eq Money.new(amount_cents)
            end
          end

        end

      end
    end

  end

end

describe 'My Job When Transferred To a Member' do

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

  it 'a subcon user should not be permitted to cancel job before accept/reject' do
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

  it 'the provider should be allowed to collect a payment' do
    expect(job.billing_status_events).to eq [:collect]
  end

  it 'billing events for subcon job can be provider_collected but it is not permitted for a user' do
    expect(subcon_job.billing_status_events).to eq [:provider_collected]
    expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job))
  end

  it 'job subcon status should be pending' do
    expect(job.subcontractor_status_name).to eq :pending
  end

  it 'the job should have no available subcon events' do
    expect(job.subcontractor_status_events).to eq []
  end

  it 'subcon_job prov status should be pending' do
    expect(subcon_job.provider_status_name).to eq :pending
  end

  it 'subcon_job should have no available provider events' do
    expect(subcon_job.provider_status_events).to eq []
  end

  context 'when prov collects' do

    describe 'collecting partial payment' do
      let(:collection_job) { job }
      let(:collector) { job.organization.users.last }
      let(:billing_status) { :partial_payment_collected_by_employee } # since the job is not done it is set to partial
      let(:billing_status_events) { [:collect, :deposited] }
      let(:billing_status_4_cash) { :partial_payment_collected_by_employee }
      let(:billing_status_events_4_cash) { [:deposited, :collect] }

      let(:customer_balance_before_payment) { 0 }
      let(:payment_amount) { 10 }
      let(:job_events) { [ServiceCallTransferEvent,
                          ScCollectedByEmployeeEvent] }

      include_examples 'successful customer payment collection', 'collect'

      it 'subcon job billing events are provider_collected but it is not permitted for a user' do
        expect(subcon_job.reload.billing_status_events).to eq [:provider_collected]
        expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
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

        it 'subcon job billing status is partially collected' do
          expect(subcon_job.reload.billing_status_name).to eq :partially_collected
        end


      end

    end

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
      job.reload
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

    it 'both the provider and the subcontractor should be allowed to collect a payment' do
      job.billing_status_events.should =~ [:collect, :subcon_collected]
    end

    it 'billing events can be provider_collected but it is not permitted for a user' do
      expect(subcon_job.billing_status_events).to eq [:provider_collected, :collect]
      expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
      expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
    end

    it 'job subcon status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'the job should have no available subcon events' do
      expect(job.subcontractor_status_events).to eq []
    end

    it 'subcon_job prov status should be pending' do
      expect(subcon_job.provider_status_name).to eq :pending
    end

    it 'subcon_job should have no available provider events' do
      expect(subcon_job.provider_status_events).to eq []
    end

    context 'when collecting customer payment' do
      include_examples 'collection before completion' do
        let(:prov_job_events) { [ServiceCallTransferEvent,
                                 ServiceCallAcceptedEvent,
                                 ScCollectedByEmployeeEvent] }
        let(:subcon_job_events) { [ServiceCallReceivedEvent,
                                   ServiceCallAcceptEvent,
                                   ScCollectEvent] }
      end
    end

    context 'when subcon collects' do

      context 'with a multi user organization' do
        before do
          subcon_job.save
          subcon.users << FactoryGirl.build(:my_technician)
          subcon.users << FactoryGirl.build(:my_technician)
        end

        describe 'collecting partial payment' do
          let(:collection_job) { subcon_job }
          let(:collector) { subcon_admin }
          let(:billing_status) { :partially_collected_by_employee } # since the job is not done it is set to partial
          let(:billing_status_events) { [:collect, :deposit_to_prov, :provider_collected] }
          let(:billing_status_4_cash) { :partially_collected_by_employee }
          let(:billing_status_events_4_cash) { [:deposit_to_prov, :provider_collected, :collect] }

          let(:customer_balance_before_payment) { 0 }
          let(:payment_amount) { 10 }
          let(:job_events) { [ServiceCallReceivedEvent,
                              ServiceCallAcceptEvent,
                              ScCollectEvent] }

          include_examples 'successful customer payment collection', 'collect'

          it 'subcon job billing events are collect and provider_collected which it is not permitted for a user' do
            expect(subcon_job.reload.billing_status_events).to eq [:provider_collected, :collect]
            expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
            expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
          end

          context 'after partial collection' do
            before do
              subcon_job.update_attributes(billing_status_event: 'collect',
                                           payment_type:         'cash',
                                           payment_amount:       payment_amount.to_s,
                                           collector:            collector)
            end

            it 'subcon status should be pending' do
              expect(subcon_job.provider_status_name).to eq :pending
            end

            it 'provider job billing status is partially collected by subcon' do
              expect(job.reload.billing_status_name).to eq :partial_payment_collected_by_subcon
            end

            it 'provider and subcon accounts are reconciled' do
              # this assumes that the payment fee is 1% therefore the payment_amount denotes the payment fee
              amount_cents = payment_amount*100 + payment_amount

              expect(subcon.becomes(Affiliate).account_for(org).balance + org.becomes(Affiliate).account_for(subcon).balance).to eq Money.new(0)
              expect(subcon.becomes(Affiliate).account_for(org).balance).to eq Money.new(amount_cents)
              expect(org.becomes(Affiliate).account_for(subcon).balance).to eq Money.new(-amount_cents)
            end

          end

        end
      end

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

      it 'the provider should be allowed to collect a payment' do
        job.billing_status_events.should =~ [:collect, :subcon_collected]
      end

      it 'billing events can be provider_collected but it is not permitted for a user' do
        expect(subcon_job.billing_status_events).to eq [:provider_collected, :collect]
        expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
        expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
      end

      it 'job subcon status should be pending' do
        expect(job.subcontractor_status_name).to eq :pending
      end

      it 'the job should have no available subcon events' do
        expect(job.subcontractor_status_events).to eq []
      end

      it 'subcon_job prov status should be pending' do
        expect(subcon_job.provider_status_name).to eq :pending
      end

      it 'subcon_job should have no available provider events' do
        expect(subcon_job.provider_status_events).to eq []
      end

      context 'when collecting customer payment' do
        include_examples 'collection before completion' do
          let(:prov_job_events) { [ServiceCallTransferEvent,
                                   ServiceCallAcceptedEvent,
                                   ServiceCallStartedEvent,
                                   ScCollectedByEmployeeEvent] }
          let(:subcon_job_events) { [ServiceCallReceivedEvent,
                                     ServiceCallAcceptEvent,
                                     ServiceCallStartEvent,
                                     ScCollectEvent] }
        end
      end

      context 'when collecting payments before and then completing the job' do

        context 'when collecting partial payment and then completing' do

          context 'when provider collected' do

            context 'when collecting cash' do

              before do
                job.update_attributes(billing_status_event: 'collect',
                                      payment_type:         'cash',
                                      payment_amount:       '10',
                                      collector:            org_admin)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new((100*100 + 100*100*0.1)*100 - 1000) #(price*qty + tax amount)*cents - paid amount
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :partial_payment_collected_by_employee
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :partially_collected
              end

            end

            context 'when collecting cheque' do

              before do
                job.update_attributes(billing_status_event: 'collect',
                                      payment_type:         'cheque',
                                      payment_amount:       '10',
                                      collector:            org_admin)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new((100*100 + 100*100*0.1)*100 - 1000) #(price*qty + tax amount)*cents - paid amount
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :partial_payment_collected_by_employee
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :partially_collected
              end

            end
          end

          context 'when subcon collected' do

            context 'when collecting cash' do

              before do
                subcon_job.update_attributes(billing_status_event: 'collect',
                                             payment_type:         'cash',
                                             payment_amount:       '10',
                                             collector:            org_admin)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new((100*100 + 100*100*0.1)*100 - 1000) #(price*qty + tax amount)*cents - paid amount
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :partial_payment_collected_by_subcon
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :partially_collected
              end

            end

            context 'when collecting cheque' do

              before do
                subcon_job.update_attributes(billing_status_event: 'collect',
                                             payment_type:         'cheque',
                                             payment_amount:       '10',
                                             collector:            org_admin)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new((100*100 + 100*100*0.1)*100 - 1000) #(price*qty + tax amount)*cents - paid amount
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :partial_payment_collected_by_subcon
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :partially_collected
              end

            end
          end

        end

        context 'when collecting full payment and then completing' do

          context 'when provider collected' do

            context 'when collecting cash' do

              before do
                job.update_attributes(billing_status_event: 'collect',
                                      payment_type:         'cash',
                                      payment_amount:       (100*100 + 100*100*0.1).to_s, #(price*qty + tax amount)*cents - paid amount
                                      collector:            org_admin)

                add_bom_to_job subcon_job, price: 100, quantity: 100, cost: 10
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new(0)
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :collected_by_employee
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :deposited
              end

            end

            context 'when collecting cheque' do

              before do
                job.update_attributes(billing_status_event: 'collect',
                                      payment_type:         'cheque',
                                      payment_amount:       (100*100 + 100*100*0.1).to_s, #(price*qty + tax amount)*cents - paid amount
                                      collector:            org_admin)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new(0)
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :collected_by_employee
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :deposited
              end

            end
          end

          context 'when subcon collected' do

            context 'when collecting cash' do

              before do
                subcon_job.update_attributes(billing_status_event: 'collect',
                                             payment_type:         'cash',
                                             payment_amount:       (100*100 + 100*100*0.1).to_s, #(price*qty + tax amount)*cents
                                             collector:            subcon)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new(0)
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :collected_by_subcon
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :collected
              end

            end

            context 'when collecting cheque' do

              before do
                subcon_job.update_attributes(billing_status_event: 'collect',
                                             payment_type:         'cheque',
                                             payment_amount:       (100*100 + 100*100*0.1).to_s, #(price*qty + tax amount)*cents - paid amount
                                             collector:            subcon)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the total - the paid amount' do
                expect(job.customer.account.balance).to eq Money.new(0)
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :collected_by_subcon
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :collected
              end

            end
          end
        end

        context 'when collecting more than the price at the completion' do

          context 'when provider collected' do

            context 'when collecting cash' do

              before do
                job.update_attributes(billing_status_event: 'collect',
                                      payment_type:         'cash',
                                      payment_amount:       (100*100 + 100*100*0.1 + 100).to_s, #(price*qty + tax amount)*cents + extra amount
                                      collector:            org_admin)

                add_bom_to_job subcon_job, price: 100, quantity: 100, cost: 10
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the residue' do
                expect(job.customer.account.balance).to eq Money.new(-100*100)
              end

              it 'job billing status should be collected by employee' do
                expect(job.billing_status_name).to eq :collected_by_employee
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :deposited
              end

              context 'when the employee deposits the payment' do
                before do
                  job.update_attributes(billing_status_event: 'deposited')
                end

                it 'job billing status should be overpaid' do
                  expect(job.billing_status_name).to eq :overpaid
                end


              end

            end

            context 'when collecting cheque' do

              before do
                job.update_attributes(billing_status_event: 'collect',
                                      payment_type:         'cheque',
                                      payment_amount:       (100*100 + 100*100*0.1 +100).to_s, #(price*qty + tax amount)*cents - paid amount
                                      collector:            org_admin)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the residue' do
                expect(job.customer.account.balance).to eq Money.new(-100*100)
              end

              it 'job billing status should be collected by employee' do
                expect(job.billing_status_name).to eq :collected_by_employee
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :deposited
              end

            end
          end

          context 'when subcon collected' do

            context 'when collecting cash' do

              before do
                subcon_job.update_attributes(billing_status_event: 'collect',
                                             payment_type:         'cash',
                                             payment_amount:       (100*100 + 100*100*0.1 +100).to_s, #(price*qty + tax amount)*cents
                                             collector:            subcon)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the residue' do
                expect(job.customer.account.balance).to eq Money.new(-100*100)
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :collected_by_subcon
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :collected
              end

            end

            context 'when collecting cheque' do

              before do
                subcon_job.update_attributes(billing_status_event: 'collect',
                                             payment_type:         'cheque',
                                             payment_amount:       (100*100 + 100*100*0.1 + 100).to_s, #(price*qty + tax amount)*cents - paid amount
                                             collector:            subcon)
                add_bom_to_job subcon_job
                subcon_job.update_attributes(tax: '10')
                subcon_job.update_attributes(work_status_event: 'complete')
                job.reload
              end

              it 'job and subcon work status should be completed' do
                expect(job.work_status_name).to eq :done
                expect(subcon_job.work_status_name).to eq :done
              end

              it 'customer balance should be the residue' do
                expect(job.customer.account.balance).to eq Money.new(-100*100)
              end

              it 'job billing status should be partially paid' do
                expect(job.billing_status_name).to eq :collected_by_subcon
              end

              it 'subcon job billing status should be partially paid' do
                expect(subcon_job.reload.billing_status_name).to eq :collected
              end

            end
          end


        end

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

        it 'subcon job work status should be done' do
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
          expect(job.reload.billing_status_events).to eq [:invoice, :subcon_invoiced, :collect, :subcon_collected]
          expect(event_permitted_for_job?('billing_status', 'invoice', org_admin, job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'subcon_invoiced', org_admin, job)).to be_false
        end

        it 'subcon job should have invoice, collect,  provider invoiced and provider collected as the available payment events, but provider invoiced/collected is not permitted' do
          expect(subcon_job.billing_status_events).to eq [:invoice, :provider_invoiced, :provider_collected, :collect]
          expect(event_permitted_for_job?('billing_status', 'invoice', subcon_admin, subcon_job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
          expect(event_permitted_for_job?('billing_status', 'provider_invoiced', subcon_admin, subcon_job)).to be_false
          expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
        end

        it 'job subcon status should be pending' do
          expect(job.reload.subcontractor_status_name).to eq :pending
        end

        it 'there should be no available events for the subcontractor status ' do
          expect(job.reload.subcontractor_status_events).to eq []
          #expect(job.reload.subcontractor_status_events).to eq [:settle, :subcon_marked_as_settled]
          #expect(event_permitted_for_job?('subcontractor_status', 'settle', subcon_admin, subcon_job)).to be_true
          #expect(event_permitted_for_job?('subcontractor_status', 'subcon_marked_as_settled', subcon_admin, subcon_job)).to be_false
          #
        end

        it 'subcon_job prov status should be pending' do
          expect(subcon_job.provider_status_name).to eq :pending
        end

        it 'subcon_job should have no available provider events' do
          expect(subcon_job.provider_status_events).to eq []
        end

        context 'when collecting customer payment' do


        end


        context 'when subcon invoices' do

          before do
            subcon_job.update_attributes(billing_status_event: 'invoice')
          end

          it 'the job status should be transferred' do
            expect(job.reload).to be_transferred
          end

          it 'the subcon job status should be accepted' do
            expect(subcon_job).to be_accepted
          end

          it 'job work status should be completed' do
            expect(job.reload).to be_work_done
          end

          it 'subcon job work status should be completed' do
            expect(subcon_job).to be_work_done
          end

          it 'job payment status should be invoiced by subcon' do
            expect(job.reload).to be_payment_invoiced_by_subcon
          end

          it 'subcon job payment status should be invoiced' do
            expect(subcon_job).to be_payment_invoiced
          end

          it 'job available status events should be cancel' do
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

          it 'job available payment events are collect and collected by subcon, but collected by subcon is not permitted for a user' do
            expect(job.reload.billing_status_events).to eq [:overdue, :collect, :subcon_collected]
            expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'subcon_collected', org_admin, job)).to be_false
          end

          it 'subcon job should have collect and provider collected as the available payment events, but provider collected is not permitted' do
            expect(subcon_job.billing_status_events).to eq [:provider_collected, :collect]
            expect(event_permitted_for_job?('billing_status', 'collect', subcon_admin, subcon_job)).to be_true
            expect(event_permitted_for_job?('billing_status', 'provider_collected', subcon_admin, subcon_job)).to be_false
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

  end

  context 'when subcon rejects the job' do
    pending
  end

end