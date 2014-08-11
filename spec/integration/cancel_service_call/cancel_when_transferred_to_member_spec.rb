require 'spec_helper'

describe 'Cancel Job When Transferred To a Member' do

  include_context 'transferred job'

  before do
    subcon_admin # ensure the subcon has a user
    transfer_the_job
  end

  it 'subcon should not be able to cancel the job' do
    expect(subcon_job.status_events).to_not include(:cancel)
  end

  it 'prov should be able to cancel the job' do
    expect(job.status_events).to include(:cancel)
  end

  describe 'subcon cancels after accepting' do

    before do
      accept_the_job subcon_job
      cancel_the_job subcon_job
      job.reload
      subcon_job.reload
    end

    it 'prov job billing status should be :pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'prov job status should be :transferred' do
      expect(job.status_name).to eq :transferred
    end

    it 'subcon job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end

    it 'prov job subcon status should be :pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'subcon job prov status should be :na' do
      expect(subcon_job.provider_status_name).to eq :na
    end

    it 'prov job subcon collection status is :pending' do
      expect(job.subcon_collection_status_name).to eq :pending
    end

    it 'subcon job prov collection status is :na' do
      expect(subcon_job.prov_collection_status_name).to eq :na
    end

    it 'prov work status should be :canceled' do
      expect(job.work_status_name).to eq :canceled
    end

    it 'subcon job work status should be :pending' do
      expect(subcon_job.work_status_name).to eq :pending
    end

  end

  describe 'after starting the work' do

    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, price: 100, quantity: 1, cost: 10, buyer: subcon
    end

    context 'when the subcon canceled the work' do
      before do
        cancel_the_job subcon_job
        job.reload
        subcon_job.reload
      end

      it 'subcon job status should be :canceled' do
        expect(subcon_job.status_name).to eq :canceled
      end

      it 'prov work status should be :canceled' do
        expect(job.work_status_name).to eq :canceled
      end

    end

    context 'when the subcon collects a payment and then cancels' do
      before do
        collect_a_payment subcon_job, amount: 50, type: 'cash'
        cancel_the_job subcon_job
        job.reload
        subcon_job.reload
      end


      it 'billing status should be :partially_collected' do
        expect(job.billing_status_name).to eq :partially_collected
      end

      it 'customer account balance should be -50' do
        expect(job.customer.account.balance).to eq Money.new(-5000)
      end

      it 'subcon job status should be :canceled' do
        expect(subcon_job.status_name).to eq :canceled
      end

      it 'prov work status should be :canceled' do
        expect(job.work_status_name).to eq :canceled
      end

      it 'prov job subcon collection status is :partially_collected' do
        expect(job.subcon_collection_status_name).to eq :partially_collected
      end

      it 'subcon job prov collection status is :collected' do
        expect(subcon_job.prov_collection_status_name).to eq :collected
      end

      context 'when subcon deposits the payment' do
        before do
          deposit_all_entries subcon_job.collection_entries
          subcon_job.reload
          job.reload
        end

        it 'prov job subcon collection status is :is_deposited' do
          expect(job.subcon_collection_status_name).to eq :is_deposited
        end

        it 'subcon job prov collection status is :is_deposited' do
          expect(subcon_job.prov_collection_status_name).to eq :is_deposited
        end

      end

      context 'when prov resets the job' do
        before do
          reset_the_job job
          job.reload
          subcon_job.reload
        end

        it 'prov work status should be :pending' do
          expect(job.work_status_name).to eq :pending
        end

        it 'prov job subcon collection status is :partially_collected' do
          expect(job.subcon_collection_status_name).to eq :partially_collected
        end

        it 'prov job subcon status is :na' do
          expect(job.subcontractor_status_name).to eq :na
        end

        it 'subcon job prov collection status is :collected' do
          expect(subcon_job.prov_collection_status_name).to eq :collected
        end


      end

      context 'when prov cancels the job' do
        before do
          cancel_the_job job
          job.reload
          subcon_job.reload
        end

        it 'billing status should be :collected' do
          expect(job.billing_status_name).to eq :collected
        end

        it 'customer account balance should be -50' do
          expect(job.customer.account.balance).to eq Money.new(-5000)
        end

        it 'subcon job status should be :canceled' do
          expect(subcon_job.status_name).to eq :canceled
        end

        it 'prov work status should be :canceled' do
          expect(job.work_status_name).to eq :canceled
        end

        it 'prov job subcon collection status is :collected' do
          expect(job.subcon_collection_status_name).to eq :collected
        end

        it 'subcon job prov collection status is :na' do
          expect(subcon_job.prov_collection_status_name).to eq :collected
        end


      end

    end


  end

  describe 'after subcon cancels' do
    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, price: 100, quantity: 1, cost: 10, buyer: subcon
      cancel_the_job subcon_job
      job.reload
    end

    it 'job status events should be :cancel and reset' do
      expect(job.status_events.sort).to eq [:cancel, :reset]
    end

    it 'the job should have a notification associated to it' do
      expect(job.notifications.where(type: 'ScCanceledNotification').size).to eq job.organization.users.size
    end

    context 'when prov cancels' do
      before do
        cancel_the_job job
      end

      it 'job status should be :canceled' do
        expect(job.status_name).to eq :canceled
      end

      it 'customer account balance should be 0' do
        expect(job.customer.account.balance).to eq Money.new(000)
      end

    end

    context 'when prov un-cancels (reset)' do
      before do
        reset_the_job job
        job.reload
      end

      it 'job status should be :new' do
        expect(job.status_name).to eq :new
      end

      it 'job work status should be :pending' do
        expect(job.work_status_name).to eq :pending
      end


      context 'when transferring again' do
        before do
          transfer_the_job job
        end

        it 'subcon should have two tickets, one canceled and one new' do
          expect(subcon.tickets.map(&:status_name).sort).to eq [:canceled, :new]
        end

      end

    end

  end

  describe 'after job is completed' do
    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, price: 100, quantity: 1, cost: 10, buyer: subcon
      complete_the_work subcon_job
      job.reload
    end

    it 'subcon should not be able to cancel the job' do
      expect(subcon_job.status_events).to_not include(:cancel)
    end

    it 'prov should not be able to cancel the job' do
      expect(job.status_events).to_not include(:cancel)
    end

  end

  describe 'when the prov cancels' do
    before do
      cancel_the_job job
      job.reload
      subcon_job.reload
    end

    it 'prov job billing status should be :pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'prov job status should be :canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'subcon job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end

    it 'prov job subcon status should be :na' do
      expect(job.subcontractor_status_name).to eq :na
    end

    it 'subcon job prov status should be :na' do
      expect(subcon_job.provider_status_name).to eq :na
    end

    it 'prov job subcon collection status is :na' do
      expect(job.subcon_collection_status_name).to eq :na
    end

    it 'subcon job prov collection status is :na' do
      expect(subcon_job.prov_collection_status_name).to eq :na
    end

    it 'prov work status should be :canceled' do
      expect(job.work_status_name).to eq :pending
    end

    it 'subcon job work status should be :pending' do
      expect(subcon_job.work_status_name).to eq :pending
    end

    it 'the subcon job should have a notification associated to it' do
      expect(subcon_job.notifications.where(type: 'ScProviderCanceledNotification').size).to be > 0
      expect(subcon_job.notifications.where(type: 'ScProviderCanceledNotification').size).to eq subcon_job.organization.users.size
    end


  end

  describe 'when the prov cancels after the subcon started the job' do
    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
      cancel_the_job job
      job.reload
      subcon_job.reload
    end

    it 'prov job billing status should be :pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'prov job status should be :canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'subcon job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end

    it 'prov job subcon status should be :na' do
      expect(job.subcontractor_status_name).to eq :na
    end

    it 'subcon job prov status should be :na' do
      expect(subcon_job.provider_status_name).to eq :na
    end

    it 'prov job subcon collection status is :na' do
      expect(job.subcon_collection_status_name).to eq :na
    end

    it 'subcon job prov collection status is :na' do
      expect(subcon_job.prov_collection_status_name).to eq :na
    end

    it 'prov work status should be :canceled' do
      expect(job.work_status_name).to eq :in_progress
    end

    it 'subcon job work status should be :pending' do
      expect(subcon_job.work_status_name).to eq :in_progress
    end

    it 'the subcon job should have a notification associated to it' do
      expect(subcon_job.notifications.where(type: 'ScProviderCanceledNotification').size).to be > 0
      expect(subcon_job.notifications.where(type: 'ScProviderCanceledNotification').size).to eq subcon_job.organization.users.size
    end

  end




end