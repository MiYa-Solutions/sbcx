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

    it 'the buyer of the broker bom should be the provider org (not the user)' do
      expect(broker_job.boms.last.buyer).to eq job.organization
    end

    it 'the buyer of the subcon bom should be the broker org' do
      expect(subcon_job.boms.last.buyer).to eq broker
    end

  end

  context 'when the broker adds a bom on behalf of the subcon' do
    before do
      add_bom_to_job broker_job, cost: 10, price: 100, quantity: 1, buyer: subcon_job.organization
      job.reload
      broker_job.reload
      subcon_job.reload
    end

    it 'bom should be added successfully' do
      expect(broker_job.boms.size).to eq 1
    end

    it 'the subcon job should have a copy of the bom' do
      expect(subcon_job.boms.size).to eq 1
      expect(subcon_job.boms.last.price).to eq job.boms.last.price
      expect(subcon_job.boms.last.cost).to eq job.boms.last.cost
      expect(subcon_job.boms.last.material).to eq job.boms.last.material
      expect(subcon_job.boms.last.quantity).to eq job.boms.last.quantity
    end

    it 'the prov job should have a copy of the bom' do
      expect(broker_job.boms.size).to eq 1
      expect(broker_job.boms.last.price).to eq job.boms.last.price
      expect(broker_job.boms.last.cost).to eq job.boms.last.cost
      expect(broker_job.boms.last.material).to eq job.boms.last.material
      expect(broker_job.boms.last.quantity).to eq job.boms.last.quantity
    end

    it 'the buyer of the prov bom should be the broker org ' do
      expect(job.boms.last.buyer).to eq broker
    end

    it 'the buyer of the subcon bom should be the subcon org' do
      expect(subcon_job.boms.last.buyer).to eq subcon_job.organization
    end


  end

  describe 'deleting boms'  do

    context 'when creating a single bom' do
      before do
        #accept_the_job subcon_job
        Authorization.current_user = subcon.users.first
        add_bom_to_job subcon_job, cost: 10, price: 100, quantity: 1, buyer: subcon_job.organization
        job.reload
        broker_job.reload
        subcon_job.reload
      end

      it 'bom should be added successfully' do
        expect(broker_job.boms.size).to eq 1
        expect(job.boms.size).to eq 1
        expect(subcon_job.boms.size).to eq 1
      end

      context 'when deleting the bom from the subcon job' do
        before do
          subcon_job.boms.last.destroy
          job.reload
          broker_job.reload
          subcon_job.reload
        end

        it 'should be deleted from the prov job' do
          expect(job.boms.size).to eq 0
        end

        it 'should be deleted from the broker job' do
          expect(broker_job.boms.size).to eq 0
        end
      end

      context 'when deleting the bom from the broker job' do
        before do
          broker_job.boms.last.destroy
          job.reload
          broker_job.reload
          subcon_job.reload
        end

        it 'should be deleted from the prov job' do
          expect(job.boms.size).to eq 0
        end

        it 'should be deleted from the subcon job' do
          expect(subcon_job.boms.size).to eq 0
        end
      end

      context 'when deleting the bom from the prov job' do
        before do
          job.boms.last.destroy
          job.reload
          broker_job.reload
          subcon_job.reload
        end

        it 'should be deleted from the broker job' do
          expect(broker_job.boms.size).to eq 0
        end

        it 'should be deleted from the subcon job' do
          expect(subcon_job.boms.size).to eq 0
        end
      end


    end

    context 'when creating multiple boms' do
      before do

      end
    end

  end

end