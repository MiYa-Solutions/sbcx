require 'spec_helper'

describe 'Service Call Transfer' do

  include_context 'transferred job'

  before do
    user.save! #to avoid stack level too deep error
  end

  it 'my job can transfer after creation' do
    expect(job.status_events).to include(:transfer)
  end

  describe 'transfer my job after the job is started' do
    before do
      start_the_job job
    end

    it 'my job can transfer after start' do
      expect(job.status_events).to include(:transfer)
    end

    context 'when job is completed' do

      before do
        complete_the_work job
      end

      it 'you can no longer transfer the job' do
        expect(job.status_events).to_not include(:transfer)
      end
    end

    context 'after transfer' do
      before do
        transfer_the_job
      end

      it 'should have the transferred status' do
        expect(job.status_name).to eq :transferred
      end
    end

    context 'transfer after adding boms' do
      before do
        add_bom_to_job job, quantity: 1, cost: 10, price: 100, buyer: job.organization
        transfer_the_job job
      end

      it 'should have the transferred status' do
        expect(job.status_name).to eq :transferred
      end

      it 'subcon job should have the bom synched' do
        expect(subcon_job.boms.size).to eq 1
        expect(subcon_job.boms.last.cost).to eq Money.new(1000)
        expect(subcon_job.boms.last.price).to eq Money.new(10000)
        expect(subcon_job.boms.last.buyer).to eq job.organization
      end

      context 'when subcon accepts the job' do
        let(:broker_agr) { FactoryGirl.build(:subcon_agreement, organization: subcon_job.organization) }
        let(:subcon2) { broker_agr.counterparty }
        let(:subcon2_job) { Ticket.where(organization_id: subcon2, ref_id: job.ref_id).first }

        before do
          accept_the_job subcon_job
        end

        context 'when the subcon completes the job' do
          before do
            start_the_job subcon_job
            complete_the_work subcon_job
          end

          it 'should not be able to transfer the work' do
            expect(subcon_job.status_events).to_not include(:transfer)
          end
        end

        context 'when the subcon transfers the job before starting' do

          before do
            broker_agr
            transfer_the_job job: subcon_job, subcon: subcon2, agreement: broker_agr
          end

          it 'subcon job status should be transferred' do
            expect(subcon_job.status_name).to eq :transferred
          end

          it 'subcon2 job should have the bom synched' do
            expect(subcon2_job.boms.size).to eq 1
            expect(subcon2_job.boms.last.cost).to eq Money.new(1000)
            expect(subcon2_job.boms.last.price).to eq Money.new(10000)
            expect(subcon2_job.boms.last.buyer).to eq subcon_job.organization
          end

        end
        context 'when the subcon starts the job ' do

          before do
            start_the_job subcon_job
            add_bom_to_job subcon_job, quantity: 2, price: 100, cost: 10
          end

          it 'should be allowed to transfer the job' do
            expect(subcon_job.status_events).to include(:transfer)
          end

          context 'when the subcon transfers the job' do
            before do
              broker_agr
              transfer_the_job job: subcon_job, subcon: subcon2, agreement: broker_agr
            end

            it 'subcon job status should be transferred' do
              expect(subcon_job.status_name).to eq :transferred
            end

            it 'subcon2 job should have the bom synched' do
              expect(subcon2_job.boms.size).to eq 2
              expect(subcon2_job.boms.last.cost).to eq Money.new(1000)
              expect(subcon2_job.boms.last.price).to eq Money.new(10000)
              expect(subcon2_job.boms.last.quantity).to eq 2
              expect(subcon2_job.boms.last.buyer).to eq subcon_job.organization
            end
          end
        end
      end

    end
  end

  describe 'job transfer rejection' do
    before do
      transfer_the_job job
      reject_the_job subcon_job
      job.reload
    end

    it 'the job can be transferred again' do
      expect(job.status_events).to include(:transfer)
    end

    it 'work status should be rejected' do
      expect(job.work_status_name).to eq :rejected
    end

    context 'when transferring the job again to the same subcon' do
      let(:subcon_job2) { TransferredServiceCall.where(ref_id: job.ref_id).last }

      before do
        transfer_the_job job
        job.reload
      end

      it 'job status should be transferred' do
        expect(job.status_name).to eq :transferred
      end

      it 'the work status should be reset to pending' do
        expect(job.work_status_name).to eq :pending
      end
      it 'another job is created' do
        expect(subcon_job2.id).to_not eq subcon_job.id
      end

    end
    context 'when transferring the job to another member subcon' do
      let(:subcon2_agr) { FactoryGirl.create(:subcon_agreement, organization: job.organization) }
      let(:subcon2) { subcon2_agr.counterparty }
      let(:subcon_job2) { TransferredServiceCall.where(ref_id: job.ref_id).last }

      before do
        transfer_the_job job: job, subcon: subcon2, agreement: subcon2_agr
      end

      it 'another job is created' do
        expect(subcon_job2.id).to_not eq subcon_job.id
        expect(subcon_job2.subcontractor_id).to_not eq subcon.id
      end

    end
    context 'when transferring the job to another local subcon' do
      let(:subcon2) { FactoryGirl.build(:local_org) }
      let(:subcon2_agr) { FactoryGirl.create(:subcon_agreement, organization: job.organization, counterparty: subcon2) }

      before do
        transfer_the_job job: job, subcon: subcon2, agreement: subcon2_agr
      end

      it 'transfer is successful' do
        expect(job.subcontractor_id).to eq subcon2.id
        expect(job.status_name).to eq :transferred
      end

    end
  end


end