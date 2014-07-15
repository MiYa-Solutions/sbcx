require 'spec_helper'

describe '3rd Party Collection' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
    collect_full_amount subcon_job
    subcon_job.collection_entries.last.deposit!

  end

  context 'when in disputed state' do
    before do
      broker_job.deposited_entries.last.dispute!

      subcon_job.reload
      broker_job.reload
      job.reload

    end

    it 'subcon collection status should be collected' do
      expect(job.subcon_collection_status_name).to eq :collected
    end

    it 'subcon collection status should be is_deposited' do
      expect(broker_job.subcon_collection_status_name).to eq :disputed
    end

    it 'provider collection status should be collected' do
      expect(broker_job.prov_collection_status_name).to eq :collected
    end

    it 'provider collection status should be is_deposited' do
      expect(subcon_job.prov_collection_status_name).to eq :disputed
    end

    context 'when confirmed' do

      before do
        broker_job.deposited_entries.last.confirm!
        broker_job.reload
        subcon_job.reload
      end
      it 'subcon collection status should be deposited' do
        expect(broker_job.subcon_collection_status_name).to eq :deposited
      end

      it 'provider collection status should be deposited' do
        expect(subcon_job.prov_collection_status_name).to eq :deposited
      end

    end
  end

end