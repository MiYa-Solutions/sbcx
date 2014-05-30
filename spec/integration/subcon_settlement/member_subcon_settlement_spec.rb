require 'spec_helper'

describe 'Member Subcon Settlement' do
  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    collect_a_payment subcon_job, amount: 100, type: 'cash', collector: subcon
  end

  it 'provider job: subcon status should be pending' do
    expect(job.subcontractor_status_name).to eq :pending
  end

  it 'subcon job: subcon status should be pending' do
    expect(subcon_job.provider_status_name).to eq :pending
  end

  it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
    expect(job.subcontractor_status_events).to eq []
  end

  it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
    expect(subcon_job.provider_status_events).to eq []
  end


  context 'when depositing the collected payment' do
    before do
      subcon_job.collection_entries.last.deposit!
      subcon_job.reload
      job.reload
    end

    it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
      expect(job.subcontractor_status_events).to eq []
    end

    it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
      expect(subcon_job.provider_status_events).to eq []
    end

    context 'when confirming the deposit' do
      before do
        job.deposited_entries.last.confirm!
        job.reload
        subcon_job.reload
      end

      it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
        expect(job.subcontractor_status_events).to eq []
      end

      it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
        expect(subcon_job.provider_status_events).to eq []
      end

      it 'subcon account balance for prov should be just the collection fee amount (100)' do
        expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(100)
      end

      it 'subcon account balance for prov should be just the collection fee amount (-100)' do
        expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(-100)
      end


      context 'when job is done' do
        before do
          subcon_job.complete_work!
          job.reload
        end

        it 'subcon account balance for prov should be: collection fee amount - subcon fee - bom reimbu' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(100 - 10000 -10000)
        end

        it 'prov account balance for prov should be: collection fee amount - subcon fee - bom reimbu' do
          expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(-100 + 10000 + 10000)
        end


        it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
          expect(job.subcontractor_status_events).to eq [:subcon_marked_as_settled, :settle]
        end

        it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
          expect(subcon_job.provider_status_events).to eq [:provider_marked_as_settled, :settle]
        end

      end


    end

  end
end