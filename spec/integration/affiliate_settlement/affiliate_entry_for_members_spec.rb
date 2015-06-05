require 'spec_helper'

describe 'Affiliate Entry For Members' do
  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
    job.reload
  end

  let(:subcon_entry) { subcon_job.provider_entries.last }
  let(:provider_entry) { job.subcon_entries.last }

  context 'when the provider initiates the settlement' do

    before do
      settle_with_subcon job, type: 'cheque', amount: '10'
    end

    it 'subcon entry should be valid' do
      expect(subcon_entry).to be_valid
    end

    it 'provider entry should be valid' do
      expect(provider_entry).to be_valid
    end

    it 'entries should reference one antoher' do
      expect(subcon_entry.matching_entry).to eq provider_entry
    end

    it 'subcon entry events should be confirm and dispute' do
      expect(subcon_entry.allowed_status_events).to eq [:dispute, :confirm]
    end

    it 'provider entry should not allow any events' do
      expect(provider_entry.allowed_status_events).to eq []
    end

    context 'when the subcon confirms the payment' do
      before do
        subcon_entry.confirm!
      end

      it 'subcon entry status should be confirmed' do
        expect(subcon_entry.status_name).to eq :confirmed
      end

      it 'provider entry status should be confirmed' do
        expect(provider_entry.status_name).to eq :confirmed
      end

      context 'when the subcon deposits the payment' do
        before do
          subcon_entry.deposit!
        end

        it 'subcon entry status should be confirmed' do
          expect(subcon_entry.status_name).to eq :deposited
        end

        it 'provider entry status should be confirmed' do
          expect(provider_entry.status_name).to eq :deposited
        end

      end
    end

  end

end