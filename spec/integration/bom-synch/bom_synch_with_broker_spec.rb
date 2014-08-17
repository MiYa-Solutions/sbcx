require 'spec_helper'

describe 'Bom Sync With Broker' do

  include_context 'brokered job'

  before do
    org_admin
    broker_admin
    subcon_admin
  end

  context 'when provider adds a bom' do
    before do
      add_bom_to_job job, cost: 10, price: 100, quantity: 1, buyer: org_admin
      job.reload
      broker_job.reload
      subcon_job.reload
    end

    it 'bom should be added successfully' do
      expect(job.boms.size).to eq 1
    end

    it 'the subcon job should have a copy of the bom' do
      expect(subcon_job.boms.size).to eq 1
      expect(subcon_job.boms.last.price).to eq job.boms.last.price
      expect(subcon_job.boms.last.cost).to eq job.boms.last.cost
      expect(subcon_job.boms.last.material).to eq job.boms.last.material
      expect(subcon_job.boms.last.quantity).to eq job.boms.last.quantity
    end

    it 'the broker job should have a copy of the bom' do
      expect(broker_job.boms.size).to eq 1
      expect(broker_job.boms.last.price).to eq job.boms.last.price
      expect(broker_job.boms.last.cost).to eq job.boms.last.cost
      expect(broker_job.boms.last.material).to eq job.boms.last.material
      expect(broker_job.boms.last.quantity).to eq job.boms.last.quantity
    end

  end

end