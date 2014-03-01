require 'spec_helper'

describe MyServiceCall do

  include_context 'basic job testing'

  subject { job }

  describe '#fully_paid?' do
    it 'should respond to a fully_paid? method' do
      expect(job).to respond_to(:fully_paid?)
    end

    it 'should return false for none paid job' do
      expect(job.fully_paid?).to be_false
    end

    context 'when paid the full amount' do
      before do
        job.start_work
        add_bom_to_job job, price: 100, quantity: 1, cost: 10

        job.update_attributes(work_status_event: 'paid', payment_type: 'cash', payment_amount: '100')
      end

      it 'should return true' do
        expect(job.fully_paid?).to be_true
      end
    end

    context 'when paid partial amount' do
      before do
        job.start_work
        add_bom_to_job job

        job.update_attributes(work_status_event: 'paid', payment_type: 'cash', payment_amount: '100')
      end

      it 'should return false' do
        expect(job.fully_paid?).to be_false
      end


    end
  end

  describe '#transfer' do
    include_context 'transferred job'

    it 'should create a SubconServiceCall' do
      expect { transfer_the_job }.to change { SubconServiceCall.count }.by(1)
    end

  end
end