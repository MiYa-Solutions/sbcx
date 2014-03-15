require 'spec_helper'
require_relative '../../shared/ticket_integration_shared_context'

describe 'Provider Job Lifecycle When Not Transferring' do
  include_context 'basic job testing'

  describe 'after job creation' do
    it 'job status should be new' do
      expect(job.status_name).to eq :new
    end
  end

  describe 'after starting the job' do
    before do
      start_the_job job
    end

    it 'status should be :open' do
      expect(job.status_name).to eq :open
    end

  end

  describe 'after adding boms' do
    before do
      start_the_job job
      add_bom_to_job job, cost: '100', price: '1000', quantity: '1'
    end

    it 'status should be :open' do
      expect(job.status_name).to eq :open
    end

  end

  describe 'after completing the job' do
    before do
      start_the_job job
      add_bom_to_job job, cost: '100', price: '1000', quantity: '1'
      complete_the_work job
    end
    it 'status should be :open' do
      expect(job.status_name).to eq :open
    end
  end

  describe 'after invoicing' do
    before do
      start_the_job job
      add_bom_to_job job, cost: '100', price: '1000', quantity: '1'
      complete_the_work job
      invoice job
    end

    it 'status should be :open' do
      expect(job.status_name).to eq :open
    end
  end

  describe 'when collecting full payment after invoicing' do
    before do
      start_the_job job
      add_bom_to_job job, cost: '100', price: '1000', quantity: '1'
      complete_the_work job
      invoice job
      collect_a_payment job, event: 'paid', amount: '1000', type: 'cash', collector: job.organization
    end

    it 'status should be :open' do
      expect(job.status_name).to eq :open
    end

    it 'status event should be :close and :cancel' do
      expect(job.status_events.sort).to eq [:cancel, :close]
    end

    context 'when canceling' do
      include_context 'when the provider cancels the job'
    end
  end

  describe 'when canceling after payment collection' do
    before do
      start_the_job job
      add_bom_to_job job, cost: '100', price: '1000', quantity: '1'
      complete_the_work job
      invoice job
      collect_a_payment job, event: 'paid', amount: '1000', type: 'cash', collector: job.organization
    end
    include_context 'when the provider cancels the job'
  end


end