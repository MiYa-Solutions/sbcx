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
            org.users << FactoryGirl.build(:additional_user)
          end

          it 'available work events should be dispatch and not start' do
            job.work_status_events.should =~ [:dispatch]
          end

          context 'when dispatching' do

            it 'status should be Dispatched'

            it 'work status should be dispatched'

            it 'payment status should be pending'

            it 'available status events should be cancel'

            it 'available work events should be start'

            it ' there should be no available payment events'

            it 'dispatch event is associated with the job'

            it 'dispatch notification is sent to the technician'

          end

        end

        context 'single user organization' do

          it 'status should be started and start time is set'

          it 'work status should be in progress'

          it 'payment status should be pending'

          it 'available status events should be cancel'

          it 'available work events should be complete'

          it 'there should be no available payment events'

          it 'start event is associated with the job'

          context 'when I complete the job' do

            it 'status should be open and completion time is set'

            it 'work status should be done'

            it 'payment status should be pending'

            it 'available status events should be cancel'

            it 'there should be no available work events'

            it 'available payment events are invoice'

            it 'complete event is associated with the job'
          end

          context 'when I invoice' do
            it 'status should be open'

            it 'work status should be done'

            it 'payment status should be invoiced'

            it 'available status events should be cancel'

            it 'there should be no available work events'

            it 'available payment events are collect'

            it 'invoice event is associated with the job'

            context 'when I collect the customer payment' do

              context 'single user organization' do

                context 'when collecting cash' do

                  it 'status should be open'

                  it 'work status should be done'

                  it 'payment status should be cleared'

                  it 'available status events should be cancel'

                  it 'there should be no available work events'

                  it 'there should be no available payment events'

                  it 'invoice event is associated with the job'
                end

                context 'when collecting none cash payment' do
                  it 'status should be open'

                  it 'work status should be done'

                  it 'payment status should be paid'

                  it 'available status events should be cancel'

                  it 'there should be no available work events'

                  it 'available payment events are reject and clear'

                  it 'invoice event is associated with the job'
                end
              end

              context 'multi user organization' do

                context 'when collecting cash' do
                  it 'status should be open'

                  it 'work status should be done'

                  it 'payment status should be collected'

                  it 'available status events should be cancel'

                  it 'there should be no available work events'

                  it 'available payment events are collect'

                  it 'invoice event is associated with the job'

                  context 'when the employee deposits the payment' do

                    it 'only the org admin is allowed to invoke the deposit event'

                    it 'status should be open'

                    it 'work status should be done'

                    it 'payment status should be deposited by employee'

                    it 'available status events should be cancel'

                    it 'there should be no available work events'

                    it 'there should be no available payment events as this is a cash payment (no clearing)'

                    it 'deposit event is associated with the job'

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

  context 'when I transfer to a member affiliate' do
    pending
  end

  context 'when I transfer to a local affiliate' do
    pending
  end

end