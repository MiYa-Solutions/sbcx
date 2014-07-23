require 'spec_helper'

describe 'Transferred Service Call Int' do


  describe '#my_profit for transferred job' do
    include_context 'transferred job'

    context 'when bom reimbursement is on' do
      before do
        transfer_the_job bom_reimbursement: 'true'
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1, buyer: subcon
        complete_the_work subcon_job
      end

      it 'my profit for subcon job should be 100.00' do
        expect(subcon_job.my_profit).to eq Money.new(10000)
      end

      it 'my profit for subcon job should be 100.00' do
        expect(job.my_profit).to eq Money.new(80000)
      end

      context 'after collection' do
        before do
          collect_a_payment subcon_job, amount: 100, type: 'cheque'
        end

        it 'my profit for subcon job should be 100.00' do
          expect(subcon_job.my_profit).to eq Money.new(9900)
        end

        it 'my profit for subcon job should be 100.00' do
          expect(job.my_profit).to eq Money.new(80100)
        end


      end

      context 'after affiliate settlement' do
        before do
          subcon_job.provider_payment = 'cash'
          subcon_job.settle_provider!
          job.reload
        end

        it 'my profit for subcon job should be 100.00' do
          expect(subcon_job.my_profit).to eq Money.new(10000)
        end

        it 'my profit for subcon job should be 100.00' do
          expect(job.my_profit).to eq Money.new(80000)
        end


      end
    end

    context 'when bom reimbursement for subcon is off' do

      before do
        transfer_the_job bom_reimbursement: 'false'
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 10, price: 500, quantity: 1, buyer: subcon
        add_bom_to_job subcon_job, cost: 10, price: 500, quantity: 1, buyer: org
        complete_the_work subcon_job
        job.reload
      end

      it 'the profit for subcon job should be 90.00' do
        expect(subcon_job.my_profit).to eq Money.new(9000)
      end

      it 'the profit for prov job should be 890.00' do
        expect(job.my_profit).to eq Money.new(89000)
      end
    end

    context 'when using profit split' do
      let(:agr_factory) { :profit_split_agreement }

      before do
        transfer_the_job
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 10, price: 500, quantity: 1, buyer: subcon
        add_bom_to_job subcon_job, cost: 10, price: 500, quantity: 1, buyer: org
        complete_the_work subcon_job

      end

      it 'my profit for subcon job should be 490.00' do
        expect(subcon_job.my_profit).to eq Money.new(49000)
      end

      it 'my profit for prov job should be 490.00' do
        expect(job.my_profit).to eq Money.new(49000)
      end

    end
  end

  describe '#my_profit for brokered job' do
    include_context 'brokered job'

    context 'when bom reimbursement is on' do
      let(:bom_reimb) { 'true' }
      before do
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1, buyer: subcon
        complete_the_work subcon_job
      end

      it 'my profit for subcon job should be 100.00' do
        expect(subcon_job.my_profit).to eq Money.new(10000)
      end

      it 'my profit for subcon job should be 100.00' do
        expect(job.my_profit).to eq Money.new(80000)
      end

      it 'my profit for subcon job should be 0' do
        expect(broker_job.my_profit).to eq Money.new(0)
      end
    end

    context 'when bom reimbursement for subcon is off' do
      let(:bom_reimb) { 'false' }
      before do
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 10, price: 500, quantity: 1, buyer: subcon
        add_bom_to_job subcon_job, cost: 10, price: 500, quantity: 1, buyer: broker
        complete_the_work subcon_job
        job.reload
      end

      it 'the profit for subcon job should be 90.00' do
        expect(subcon_job.my_profit).to eq Money.new(9000)
      end

      it 'the profit for prov job should be 900.00' do
        expect(job.my_profit).to eq Money.new(90000)
      end

      it 'the profit for broker job should be -10.00' do
        expect(broker_job.my_profit).to eq Money.new(-1000)
      end
    end

  end

end