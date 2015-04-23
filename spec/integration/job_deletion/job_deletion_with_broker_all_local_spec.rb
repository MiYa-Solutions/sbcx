require 'spec_helper'

describe 'Job deletion with broker all local', skip_basic_job: true do
  let(:broker_job) { BrokerServiceCall.find(job.id) }

  before do
    job.save!
  end

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end

  include_context 'job transferred to local subcon'


  it 'should deletion should be successful' do
    expect { job.destroy }.to change(Ticket, :count).by(-1)
  end

  context 'when adding boms and starting the job' do
    before do
      job.update_attributes(properties: { 'provider_fee' => '100', 'prov_bom_reimbursement' => 'true' })
      accept_the_job job
      add_bom_to_job job
      add_bom_to_job job
      transfer_the_job
      accept_on_behalf_of_subcon broker_job
      start_the_job broker_job
    end

    it 'should destroy appointments when destroying the job' do
      job.appointments << Appointment.new(starts_at: 1.day.from_now, ends_at: (1.day.from_now.to_time + 1.hours).to_datetime)
      expect {job.destroy}.to change(Appointment, :count).by(-1)
    end

    context 'when destroying the job' do

      it 'the job boms should be delete' do
        expect{broker_job.destroy}.to change(Bom, :count).by(-2)
      end

      it 'the events should be deleted' do
        expect{broker_job.destroy}.to change(Event, :count).by(-4)
      end

      it 'the notifications should be deleted' do
        expect{broker_job.destroy}.to change(Notification, :count).by(-1)

      end

    end

    context 'when completing the work' do
      before do
        complete_the_work broker_job
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
          broker_job.destroy
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