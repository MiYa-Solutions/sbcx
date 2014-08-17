require 'spec_helper'

describe 'Creating BOM Before Transfer' do

  include_context 'transferred job'

  before do
    user.save!
    add_bom_to_job job, price: 100, cost: 10, quantity: 1
  end

  it 'bom should be added successfully' do
    expect(job.boms.size).to eq 1
  end

  context 'when transferring the job' do
    before do
      transfer_the_job job
    end

    it 'the subcon job should have a copy of the bom' do
      expect(subcon_job.boms.size).to eq 1
      expect(subcon_job.boms.last.price).to eq job.boms.last.price
      expect(subcon_job.boms.last.cost).to eq job.boms.last.cost
      expect(subcon_job.boms.last.material).to eq job.boms.last.material
      expect(subcon_job.boms.last.quantity).to eq job.boms.last.quantity
    end

    context 'when adding a bom to the subcon job' do
      before do
        add_bom_to_job subcon_job, price: 300, cost: 50, quantity: 2
        job.reload
        subcon_job.reload
      end

      it 'the subcon job should have a copy of the bom' do
        expect(subcon_job.boms.size).to eq 2
        expect(subcon_job.boms.last.price).to eq job.boms.last.price
        expect(subcon_job.boms.last.cost).to eq job.boms.last.cost
        expect(subcon_job.boms.last.material).to eq job.boms.last.material
        expect(subcon_job.boms.last.quantity).to eq job.boms.last.quantity
      end

      it 'bom should be added successfully' do
        expect(job.boms.size).to eq 2
        expect(job.boms.last.price).to eq subcon_job.boms.last.price
        expect(job.boms.last.cost).to eq subcon_job.boms.last.cost
        expect(job.boms.last.material).to eq subcon_job.boms.last.material
        expect(job.boms.last.quantity).to eq subcon_job.boms.last.quantity
      end

      context 'when provider deletes his bom' do
        before do
          job.boms.last.destroy
        end

        it 'subcon job should have the synched bom deleted' do
          expect(subcon_job.boms.size).to eq 1
          expect(subcon_job.boms.last.price).to eq job.boms.last.price
          expect(subcon_job.boms.last.cost).to eq job.boms.last.cost
          expect(subcon_job.boms.last.material).to eq job.boms.last.material
          expect(subcon_job.boms.last.quantity).to eq job.boms.last.quantity
        end

        it 'bom should be deleted successfully' do
          expect(job.boms.size).to eq 1
          expect(job.boms.last.price).to eq subcon_job.boms.last.price
          expect(job.boms.last.cost).to eq subcon_job.boms.last.cost
          expect(job.boms.last.material).to eq subcon_job.boms.last.material
          expect(job.boms.last.quantity).to eq subcon_job.boms.last.quantity
        end

      end


    end
  end

end