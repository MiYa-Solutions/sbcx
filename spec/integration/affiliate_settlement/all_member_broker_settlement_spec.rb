require 'spec_helper'

describe 'All Members Broker Settlement' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
  end

  context 'when the broker marks the job as settled with the subcon' do
    before do
      mark_as_settled_subcon broker_job
      job.reload
      subcon_job.reload
    end

    it 'broker subcontractor status should be claim_settled' do
      expect(broker_job.subcontractor_status_name).to eq :claim_settled
    end

    it 'provider subcontractor status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'broker provider status should be pending' do
      expect(broker_job.provider_status_name).to eq :pending
    end

    it 'subcontractor provider status should be claimed_as_settled' do
      expect(subcon_job.provider_status_name).to eq :claimed_as_settled
    end

    it 'broker balance with subcon should be zero' do
      expect(broker.account_for(subcon).balance).to eq Money.new(0)
    end

    it 'subcon balance with broker should be zero' do
      expect(subcon.account_for(broker).balance).to eq Money.new(0)
    end

    it 'broker balance with provider should be 200.00 (subcon fee +  bom reimb)' do
      expect(broker.account_for(org).balance).to eq Money.new(20000)
    end

    it 'prov balance with broker should be 200.00 (subcon fee + bom reimb)' do
      expect(org.account_for(broker).balance).to eq Money.new(-20000)
    end
  end
  context 'when the broker marks the job as settled with the provider' do

  end
  context 'when the subcon marks the job as settled with the broker' do
    before do
      mark_as_settled_prov subcon_job
      job.reload
      broker_job.reload
    end

    it 'broker subcontractor status should be claimed_as_settled' do
      expect(broker_job.subcontractor_status_name).to eq :claimed_as_settled
    end

    it 'provider subcontractor status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'broker provider status should be pending' do
      expect(broker_job.provider_status_name).to eq :pending
    end

    it 'subcontractor provider status should be claimed_as_settled' do
      expect(subcon_job.provider_status_name).to eq :claim_settled
    end

    it 'broker balance with subcon should be zero' do
      expect(broker.account_for(subcon).balance).to eq Money.new(0)
    end

    it 'subcon balance with broker should be zero' do
      expect(subcon.account_for(broker).balance).to eq Money.new(0)
    end

    it 'broker balance with provider should be 200.00 (subcon fee +  bom reimb)' do
      expect(broker.account_for(org).balance).to eq Money.new(20000)
    end

    it 'prov balance with broker should be 200.00 (subcon fee + bom reimb)' do
      expect(org.account_for(broker).balance).to eq Money.new(-20000)
    end

    context 'when the broker confirms the the subcon settlement' do
      before do
        confirm_settled_subcon broker_job
        job.reload
        subcon_job.reload
      end

      it 'broker subcontractor status should be cleared' do
        expect(broker_job.subcontractor_status_name).to eq :cleared
      end

      it 'provider subcontractor status should be pending' do
        expect(job.subcontractor_status_name).to eq :pending
      end

      it 'broker provider status should be pending' do
        expect(broker_job.provider_status_name).to eq :pending
      end

      it 'subcontractor provider status should be cleared' do
        expect(subcon_job.provider_status_name).to eq :cleared
      end

      it 'broker balance with subcon should be zero' do
        expect(broker.account_for(subcon).balance).to eq Money.new(0)
      end

      it 'subcon balance with broker should be zero' do
        expect(subcon.account_for(broker).balance).to eq Money.new(0)
      end

      it 'broker balance with provider should be 200.00 (subcon fee +  bom reimb)' do
        expect(broker.account_for(org).balance).to eq Money.new(20000)
      end

      it 'prov balance with broker should be 200.00 (subcon fee + bom reimb)' do
        expect(org.account_for(broker).balance).to eq Money.new(-20000)
      end

      context 'when the broker settles with the provider' do
        before do
          mark_as_settled_prov broker_job
          job.reload
          subcon_job.reload
        end
        it 'broker subcontractor status should be cleared' do
          expect(broker_job.subcontractor_status_name).to eq :cleared
        end

        it 'provider subcontractor status should be pending' do
          expect(job.subcontractor_status_name).to eq :claimed_as_settled
        end

        it 'broker provider status should be pending' do
          expect(broker_job.provider_status_name).to eq :claim_settled
        end

        it 'subcontractor provider status should be cleared' do
          expect(subcon_job.provider_status_name).to eq :cleared
        end

        it 'broker balance with subcon should be zero' do
          expect(broker.account_for(subcon).balance).to eq Money.new(0)
        end

        it 'subcon balance with broker should be zero' do
          expect(subcon.account_for(broker).balance).to eq Money.new(0)
        end

        it 'broker balance with provider should be 0.00' do
          expect(broker.account_for(org).balance).to eq Money.new(0)
        end

        it 'prov balance with broker should be 0.00' do
          expect(org.account_for(broker).balance).to eq Money.new(0)
        end

      end

    end

  end
  context 'when the provider marks the job as settled with the broker'

end