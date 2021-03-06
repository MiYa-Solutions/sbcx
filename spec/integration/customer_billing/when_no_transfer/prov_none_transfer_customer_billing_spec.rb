require 'spec_helper'

describe 'Customer Billing When No Provider Transfer' do

  include_context 'basic job testing'

  context 'when I create the job' do

    it 'payment status should be pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'available billing status should be ' do
      expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
    end

    context 'when I start the job' do

      context 'multi user organization' do
        let!(:technician) do
          tech = FactoryGirl.build(:my_technician)
          org.users << tech
          tech
        end

        it 'available billing events should be collect' do
          expect(job.billing_status_events.sort).to eq  [:collect, :late, :reopen]
        end

        describe 'collecting payment' do
          describe 'collecting full payment' do
            include_examples 'successful customer payment collection', 'collect' do
              let(:collection_job) { job }
              let(:collector) { job.organization.users.last }
              let(:billing_status) { :partially_collected }        # since the job is not done it is set to partial
              let(:billing_status_4_cash) { :partially_collected } # since the job is not done it is set to partial
              let(:subcon_collection_status) { :na }
              let(:subcon_collection_status_4_cash) { :na }
              let(:prov_collection_status) { nil }
              let(:prov_collection_status_4_cash) { nil }

              let(:customer_balance_before_payment) { 0 }
              let(:payment_amount) { 100 }
              let(:job_events) { [ScCollectEvent] }

              let(:the_prov_job) { nil }
            end
          end

          describe 'collecting partial payment' do
            include_examples 'successful customer payment collection', 'collect' do
              let(:collection_job) { job }
              let(:collector) { job.organization.users.last }
              let(:billing_status) { :partially_collected }        # since the job is not done it is set to partial
              let(:billing_status_4_cash) { :partially_collected } # since the job is not done it is set to partial
              let(:subcon_collection_status) { :na }
              let(:subcon_collection_status_4_cash) { :na }
              let(:prov_collection_status) { nil }
              let(:prov_collection_status_4_cash) { nil }

              let(:customer_balance_before_payment) { 0 }
              let(:payment_amount) { 10 }
              let(:job_events) { [ScCollectEvent] }
              let(:the_prov_job) { nil }

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

          it 'available payment events are collect late and reopen' do
            expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
          end

          context 'when collecting payment' do

            context 'when collecting cash' do

              context 'when collecting the full amount' do
                before do
                  collect_a_payment job, type: 'cash', amount: '100', collector: technician
                end

                it 'payment status should be partially_collected' do
                  expect(job.billing_status_name).to eq :partially_collected
                end

                it 'available payment events are :collect, :late, :reject :cancel and :reopen' do
                  expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reject, :reopen]
                end

                it 'collect event is associated with the job' do
                  expect(job.events.map { |e| e.class.name }.sort).to eq ['ScCollectEvent', 'ServiceCallDispatchEvent']
                end

                it 'the technician is not allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', technician, job)).to be_false
                end

                it 'customer balance should be zero' do
                  expect(job.customer.account.balance).to eq 0
                end


                context 'when the employee deposits the payment' do
                  pending 'uncomment once implemented employee billing service'

                  #before do
                  #  confirm_employee_deposit job.collection_entries.last
                  #end
                  #
                  #it 'payment status should be cleared' do
                  #  expect(job.billing_status_name).to eq :cleared
                  #end
                  #
                  #it 'available status events should be cancel and close' do
                  #  job.status_events.should =~ [:cancel, :close]
                  #end
                  #
                  #it 'there should be no available work events' do
                  #  job.work_status_events.should =~ []
                  #end
                  #
                  #it 'there should be no available payment events as this is a cash payment (no clearing)' do
                  #  job.billing_status_events.should eq []
                  #end
                  #
                  #it 'employee deposited event is associated with the job' do
                  #  job.events.map(&:class).should =~ [ServiceCallStartEvent,
                  #                                     ServiceCallDispatchEvent,
                  #                                     ServiceCallCompleteEvent,
                  #                                     ServiceCallInvoiceEvent,
                  #                                     ScCollectedByEmployeeEvent,
                  #                                     ScEmployeeDepositedEvent]
                  #end

                end
              end

              context 'when collecting partial amount' do
                before do
                  collect_a_payment job, type: 'cash', amount: '10', collector: technician
                end

                it 'status should be open' do
                  expect(job).to be_open
                end

                it 'payment status should be partially_collected' do
                  expect(job.billing_status_name).to eq :partially_collected
                end

                it 'available status events should be cancel' do
                  job.status_events.should =~ [:cancel, :transfer]
                end

                it 'available payment events are cancel , collect late reject and reopen' do
                  expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reject, :reopen]
                end


                it 'the technician is not allowed to invoke the deposit event' do
                  expect(event_permitted_for_job?('billing_status', 'deposited', technician, job)).to be_false
                end


              end
            end

            context 'when collecting none cash payment' do

              before do
                collect_a_payment job, type: 'credit_card', amount: '100', collector: technician
              end

              it 'payment status should be partially_collected' do
                expect(job.billing_status_name).to eq :partially_collected
              end

              it 'available payment events are [:cancel, :collect, :late, :reject, :reopen]' do
                job.billing_status_events.should =~ [:cancel, :collect, :late, :reject, :reopen]
              end

            end


          end


        end

      end

      context 'with single user organization' do
        before do
          job.update_attributes(work_status_event: 'start')
        end

        it 'payment status should be pending' do
          expect(job).to be_payment_pending
        end

        it 'collect late and reopen are the available payment events' do
          expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
        end

        context 'partial payment' do
          before do
            collect_a_payment job, type: 'cash', amount: '10', collector: org
          end

          it 'payment status should be partially paid' do
            expect(job.billing_status_name).to eq :partially_collected
          end

          it 'available payment events are [:cancel, :collect, :late, :reject, :reopen]' do
            expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reject, :reopen]
          end

          it 'payment event is associated with the job' do
            expect(job.events.map { |e| e.class.name }.sort).to eq ['ScCollectEvent', 'ServiceCallStartEvent']
          end

          it 'payment amount is the submitted one' do
            expect(job.events.where(type: 'ScCollectEvent').first.amount).to eq Money.new_with_amount(10)
          end

          context 'when payment is overdue' do
            before do
              job.late_payment!
            end

            it 'billing status should be :overdue' do
              expect(job.billing_status_name).to eq :overdue
            end

            it 'available payment events are [:cancel, :collect, :reopen]' do
              expect(job.billing_status_events.sort).to eq [:cancel, :collect, :reopen]
            end

            context 'when collecting another payment' do
              before do
                collect_a_payment job, type: 'cash', amount: '10', collector: org
                job.reload
              end

              it 'billing status should be :partially_collected' do
                expect(job.billing_status_name).to eq :partially_collected
              end


            end


          end


        end

        context 'when I complete the job' do

          context 'when a preliminary cash payment was made before the completion' do
            before do
              collect_a_payment job, type: 'cash', amount: '100', collector: org
            end


            context 'when the preliminary cash payment was for the full amount' do
              before do
                add_bom_to_job job, price: 100, cost: 10, quantity: 1
              end


              context 'when payment is deposited' do
                before do
                  job.payments.sort.last.deposit!
                end

                it 'payment status should be paid' do
                  expect(job.reload.billing_status_name).to eq :partially_collected
                end

                context 'when completing the work' do
                  before do
                    complete_the_work job
                  end

                  it 'payment status should be paid' do
                    expect(job.reload.billing_status_name).to eq :paid
                  end

                end

              end

              context 'when completing the work' do
                before do
                  complete_the_work job
                end

                it 'work status should be done' do
                  expect(job).to be_work_done
                end

                it 'payment status should be collected' do
                  expect(job.billing_status_name).to eq :collected
                end

                context 'when payment is deposited' do
                  before do
                    job.payments.sort.last.deposit!
                  end

                  it 'payment status should be paid' do
                    expect(job.reload.billing_status_name).to eq :paid
                  end

                end

              end
            end

            context 'when the preliminary payment was for a partial amount' do
              before do
                add_bom_to_job job, price: 1000, cost: 10, quantity: 1
                complete_the_work job
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be partially_paid' do
                expect(job.billing_status_name).to eq :partially_collected
              end

              context 'when payment is overdue' do
                before do
                  job.late_payment!
                end

                it 'billing status should be :overdue' do
                  expect(job.billing_status_name).to eq :overdue
                end

                it 'available payment events are [:cancel, :collect, :reopen]' do
                  expect(job.billing_status_events.sort).to eq [:cancel, :collect, :reopen]
                end

                context 'when collecting another partial payment' do
                  before do
                    collect_a_payment job, type: 'cash', amount: '100', collector: org
                    job.reload
                  end

                  it 'billing status should be :partially_collected' do
                    expect(job.billing_status_name).to eq :overdue
                  end

                  context 'when collecting the full amount' do
                    before do
                      collect_a_payment job, type: 'cheque', amount: '800', collector: org
                    end

                    it 'billing status should be :collected' do
                      expect(job.billing_status_name).to eq :collected
                    end

                  end


                end


              end

            end
          end

          context 'when a preliminary cheque payment was made before the completion' do
            before do
              collect_a_payment job, type: 'cheque', amount: '100', collector: org
            end


            context 'when the preliminary cash payment was for the full amount' do
              before do
                add_bom_to_job job, price: 100, cost: 10, quantity: 1
              end


              context 'when payment is deposited' do
                before do
                  job.payments.sort.last.deposit!
                end

                it 'payment status should be paid' do
                  expect(job.reload.billing_status_name).to eq :partially_collected
                end

                context 'when completing the work' do
                  before do
                    complete_the_work job
                  end

                  it 'payment status should be paid' do
                    expect(job.reload.billing_status_name).to eq :in_process
                  end

                end

                context 'when clearing the cheque' do
                  before do
                    job.payments.sort.last.clear!
                  end

                  it 'payment status should be paid' do
                    expect(job.reload.billing_status_name).to eq :partially_collected
                  end

                  context 'when completing the work' do
                    before do
                      complete_the_work job
                    end

                    it 'payment status should be paid' do
                      expect(job.reload.billing_status_name).to eq :paid
                    end

                  end


                end

              end

              context 'when completing the work' do
                before do
                  complete_the_work job
                end

                it 'work status should be done' do
                  expect(job).to be_work_done
                end

                it 'payment status should be collected' do
                  expect(job.billing_status_name).to eq :collected
                end

                context 'when payment is deposited' do
                  before do
                    job.payments.sort.last.deposit!
                  end

                  it 'payment status should be in_process' do
                    expect(job.reload.billing_status_name).to eq :in_process
                  end

                end

              end
            end

            context 'when the preliminary payment was for a partial amount' do
              before do
                add_bom_to_job job, price: 1000, cost: 10, quantity: 1
                job.update_attributes(work_status_event: 'complete')
              end

              it 'work status should be done' do
                expect(job).to be_work_done
              end

              it 'payment status should be partially_paid' do
                expect(job.billing_status_name).to eq :partially_collected
              end

              context 'when payment is overdue' do
                before do
                  job.late_payment!
                end

                it 'billing status should be :overdue' do
                  expect(job.billing_status_name).to eq :overdue
                end

                it 'available payment events are [:cancel, :collect, :reopen]' do
                  expect(job.billing_status_events.sort).to eq [:cancel, :collect, :reopen]
                end

                context 'when collecting another partial payment' do
                  before do
                    collect_a_payment job, type: 'cash', amount: '100', collector: org
                    job.reload
                  end

                  it 'billing status should be :partially_collected' do
                    expect(job.billing_status_name).to eq :overdue
                  end

                  context 'when collecting the full amount' do
                    before do
                      collect_a_payment job, type: 'cheque', amount: '800', collector: org
                    end

                    it 'billing status should be :collected' do
                      expect(job.billing_status_name).to eq :collected
                    end

                  end


                end


              end

            end
          end

          context 'when there was no preliminary payment' do
            before do
              add_bom_to_job job, price: 100, cost: 10, quantity: 1
              job.update_attributes(work_status_event: 'complete')
            end

            it 'work status should be done' do
              expect(job).to be_work_done
            end

            it 'payment status should be pending' do
              expect(job.billing_status_name).to eq :pending
            end

            it 'available payment events are [:collect, :late, :reopen]' do
              expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
            end

            context 'when I collect the customer payment' do

              context 'when collecting cash' do

                context 'when collecting the full payment' do
                  before do
                    collect_a_payment job, type: 'cash', amount: '100', collector: org
                  end

                  it 'payment status should be collected' do
                    expect(job.billing_status_name).to eq :collected
                  end

                  context 'when depositing the payment' do
                    before do
                      job.payments.last.deposit!
                      job.reload
                    end

                    it 'payment status should be cleared' do
                      expect(job.payments.last.status_name).to eq :cleared
                    end

                    it 'payment status should be paid' do
                      expect(job.billing_status_name).to eq :paid
                    end

                    it '[:cancel, :reopen] are the available payment events' do
                      expect(job.billing_status_events.sort).to eq [:cancel, :reopen]
                    end
                  end
                end

                context 'when collecting partial payment' do
                  before do
                    collect_a_payment job, type: 'cash', amount: '10', collector: org
                  end

                  it 'payment status should be partially collected' do
                    expect(job.billing_status_name).to eq :partially_collected
                  end

                  it 'available payment events are [:cancel, :late, :collect, :reject, :reopen]' do
                    expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reject, :reopen]
                  end

                  it 'payment amount is the submitted one' do
                    expect(job.events.where(type: 'ScCollectEvent').first.amount).to eq Money.new_with_amount(10)
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
                      collect_a_payment job, type: 'cash', amount: '10', collector: org
                    end

                    it 'payment status should be partially paid' do
                      expect(job.billing_status_name).to eq :partially_collected
                    end

                    describe 'billing' do
                      describe 'customer billing' do
                        it 'balance should be 10' do
                          expect(job.customer.account.reload.balance).to eq Money.new(10000 - 2000, 'USD')
                        end
                      end
                    end

                    context 'when collecting the remainder' do
                      before do
                        collect_a_payment job, type: 'cash', amount: '80', collector: org
                      end
                      context 'when depositing the payment' do
                        before do
                          job.payments.each { |payment| payment.deposit! }
                        end
                        it 'payment status should be paid' do
                          expect(job.reload.billing_status_name).to eq :paid
                        end
                      end
                    end


                  end

                end

              end

              context 'when collecting none cash payment' do

                context 'when collecting partial amount' do
                  before do
                    collect_a_payment job, type: 'cheque', amount: '10', collector: org
                  end

                  it 'payment status should be partially paid' do
                    expect(job.billing_status_name).to eq :partially_collected
                  end

                  it 'collection and late events are allowed' do
                    expect(job.billing_status_events).to include :late
                    expect(job.billing_status_events).to include :collect
                  end

                  it 'only collect and late  are events allowed for a user' do
                    expect(event_permitted_for_job?('billing_status', 'late', org_admin, job)).to be_true
                    expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true

                  end

                  context 'when payment is rejected' do
                    before do
                      job.payments.last.reject!
                      job.reload
                    end

                    it 'payment status is set to partially_collected' do
                      expect(job.billing_status_name).to eq :rejected
                    end

                    it 'should have collect, and late as possible payment events, both available for the user' do
                      expect(job.billing_status_events.sort).to eq [:cancel, :collect, :late, :reopen]
                      expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
                      expect(event_permitted_for_job?('billing_status', 'late', org_admin, job)).to be_true
                      expect(event_permitted_for_job?('billing_status', 'reopen', org_admin, job)).to be_false
                      expect(event_permitted_for_job?('billing_status', 'cancel', org_admin, job)).to be_false
                    end

                    context 'when adding another payment for the full amount' do
                      before do
                        collect_a_payment job, type: 'credit_card', amount: '100', collector: org
                      end

                      it 'payment status should be in_process' do
                        expect(job.billing_status_name).to eq :collected
                      end

                      describe 'when depositing the payment' do
                        before do
                          job.payments.last.deposit!
                        end
                        context 'when clearing the payment' do
                          include_context 'clear payment' do
                            let(:entry) { job.customer.account.payments.order('ID ASC').last }
                          end

                          it 'payment status is set to paid' do
                            expect(job.reload.billing_status_name).to eq :paid
                          end

                        end

                        context 'when rejecting the payment' do
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


                        end
                      end

                    end

                    context 'when adding another payment for the partial amount' do
                      before do
                        collect_a_payment job, type: 'credit_card', amount: '10', collector: org
                      end

                      it 'payment status should be partially paid' do
                        expect(job.billing_status_name).to eq :partially_collected
                      end

                      context 'when clearing the payment' do
                        include_context 'clear payment' do
                          let(:entry) { job.customer.account.payments.order('ID ASC').last }
                        end

                        it 'job payment status is set to partially paid' do
                          expect(job.reload.billing_status_name).to eq :partially_collected
                        end

                        context 'when paying additional payment (not the complete amount yet)' do
                          before do
                            collect_a_payment job, type: 'cash', amount: '70', collector: org
                          end

                          it 'payment status should be partially paid' do
                            expect(job.billing_status_name).to eq :partially_collected
                          end
                          context 'when paying additional payment for the remainder of the amount' do
                            before do
                              collect_a_payment job, type: 'cash', amount: '20', collector: org
                            end

                            it 'payment status should be collected' do
                              expect(job.billing_status_name).to eq :collected
                            end

                            describe 'when depositing all the payments' do
                              before do
                                job.payments.each { |payment| payment.deposit! if payment.can_deposit? }
                              end

                              it 'payment status should be cleared' do
                                expect(job.reload.billing_status_name).to eq :paid
                              end
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
                      expect(job.billing_status_name).to eq :partially_collected
                    end
                  end
                end

                context 'when collecting the full amount' do
                  before do
                    collect_a_payment job, type: 'cheque', amount: '100', collector: org
                  end

                  it 'payment status should be collected' do
                    expect(job.billing_status_name).to eq :collected
                  end

                  describe 'when depositing the cheque' do
                    before do
                      job.payments.last.deposit!
                      job.reload
                    end

                    it 'should change customer billing status to in_process' do
                      expect(job.billing_status_name).to eq :in_process
                    end

                    it 'available payment events are reject and reopen which is not available to a user' do
                      expect(job.billing_status_events).to eq [:reject, :reopen]
                      expect(event_permitted_for_job?('billing_status', 'reject', org_admin, job)).to be_false
                      expect(event_permitted_for_job?('billing_status', 'reopen', org_admin, job)).to be_false
                    end


                    context 'when payment is rejected' do

                      include_context 'reject payment' do
                        let(:entry) { job.customer.account.payments.order('ID ASC').last }
                      end

                      it 'payment status is set to rejected' do
                        expect(job.reload.billing_status_name).to eq :rejected
                      end

                      it 'should have collect and late as possible payment events both available for a user' do
                        expect(job.reload.billing_status_events.sort).to eq [:cancel, :collect, :late, :reopen]
                        expect(event_permitted_for_job?('billing_status', 'collect', org_admin, job)).to be_true
                        expect(event_permitted_for_job?('billing_status', 'late', org_admin, job)).to be_true
                        expect(event_permitted_for_job?('billing_status', 'cancel', org_admin, job)).to be_false
                        expect(event_permitted_for_job?('billing_status', 'reopen', org_admin, job)).to be_false
                      end
                    end

                    context 'when payment is cleared' do
                      include_context 'clear payment' do
                        let(:entry) { job.customer.account.payments.order('ID ASC').last }
                      end

                      it 'payment status is set to cleared' do
                        expect(job.reload.billing_status_name).to eq :paid
                      end


                      it 'should have no payment events' do
                        expect(job.reload.billing_status_events).to_not include :collect
                        expect(job.reload.billing_status_events).to_not include :late
                      end
                    end
                  end
                end

              end

            end

            context 'when payment is overdue' do
              before do
                job.late_payment!
              end

              it 'billing status should be :overdue' do
                expect(job.billing_status_name).to eq :overdue
              end

              it 'available payment events are [:cancel, :collect, :reopen]' do
                expect(job.billing_status_events.sort).to eq [:cancel, :collect, :reopen]
              end


            end


          end

        end

      end


    end

    context 'trivial credit card collection' do

      before do
        start_the_job job
        add_bom_to_job job, cost: 100, price: 1000, quantity: 1
        complete_the_work job
        collect_a_payment job, amount: 1000, type: 'credit_card', collector: org
      end

      context 'when deposting the payment' do
        before do
          job.payments.last.deposit!
        end

        context 'when clearing the payment' do
          before do
            job.payments.last.clear!
            job.reload
          end

          it 'billing status should be paid' do
            expect(job.billing_status_name).to eq :paid
          end
        end
      end


    end

  end

end