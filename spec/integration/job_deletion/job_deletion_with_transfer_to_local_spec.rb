require 'spec_helper'

describe 'Job deletion when transferring to a local subcon' do

  include_context 'job transferred to local subcon'

  before do
    job.save!
  end

  it 'deletion should be successful' do
    expect { delete_the_ticket(job) }.to change(Ticket, :count).by(-1)
  end

  context 'when adding boms and starting the job' do
    before do
      add_bom_to_job job
      add_bom_to_job job
      transfer_the_job job
      accept_on_behalf_of_subcon job
      start_the_job job
    end


    context 'when destroying the job' do

      it 'should destroy appointments when destroying the job' do
        job.appointments << Appointment.new(starts_at: 1.day.from_now, ends_at: (1.day.from_now.to_time + 1.hours).to_datetime)
        expect { delete_the_ticket(job) }.to change(Appointment, :count).by(-1)
      end

      it 'the job boms should be delete' do
        expect { delete_the_ticket(job) }.to change(Bom, :count).by(-2)
      end

      it 'the events should be deleted' do
        event_types = job.events.map(&:type)
        expect { delete_the_ticket(job) }.to change(Event.where(type: event_types), :count).by(-event_types.size)
      end

      it 'should log an event under the organization' do
        expect { delete_the_ticket(job) }.to change(org.events.where(type: 'TicketDeletionEvent'), :size).by(1)
      end

    end

    context 'when completing the work' do
      before do
        complete_the_work job
      end

      it 'the customer balance should be more than zero' do
        expect(customer.account.reload.balance).to be > 0
      end

      it 'the customer balance should be more than zero' do
        expect(org.account_for(subcon).reload.balance).to be < 0
      end

      it 'accounting entries should be deleted' do
        expect(AccountingEntry.count).to be > 0
      end


      context 'when destroying the job' do
        before do
          delete_the_ticket(job)
        end

        it 'accounting entries should be deleted' do
          expect(AccountingEntry.count).to eq 0
        end

        it 'the customer balance should be more than zero' do
          expect(customer.account.reload.balance).to eq 0
        end


      end
    end


  end
end