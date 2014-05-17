require 'spec_helper'

describe '3rd Party Collection' do

  include_context 'brokered job'


  context 'when in is_deposited state' do

    context 'when broker collects fully' do

      before do
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
        collect_a_payment broker_job, amount: 1000, type: 'cash', collector: broker
        complete_the_work subcon_job
        broker_job.collection_entries.last.deposit!

      end

      it 'broker job: prov collection status should be is_deposited' do
        expect(broker_job.reload.prov_collection_status_name).to eq :is_deposited
      end

      it 'prov job: subcon collection status should be is_deposited' do
        expect(job.reload.subcon_collection_status_name).to eq :is_deposited
      end

      it 'broker: account balance for prov should be 190.00 (the flat fee + bom reimb. - cash collection fee)' do
        expect(broker.account_for(org).balance).to eq Money.new(19000)
      end

      it 'the broker can''t collect another payment' do
        expect(broker_job.reload.billing_status_events).to eq []
      end

      it 'the broker can''t collect another payment' do
        expect(subcon_job.reload.billing_status_events).to eq []
      end

      context 'when the provider confirms the deposit' do
        before do
          job.reload.deposited_entries.last.confirm!
        end
        it 'billing status should be deposited' do
          expect(broker_job.reload.prov_collection_status_name).to eq :deposited
        end
        it 'billing status should be deposited' do
          expect(job.reload.subcon_collection_status_name).to eq :deposited
        end
        it 'deposit entry status should be confirmed' do
          expect(broker_job.reload.deposit_entries.last.status_name).to eq :confirmed
        end

        it 'broker: account balance for prov should be 190.00 (the flat fee + bom reimb. - cash collection fee)' do
          expect(broker.account_for(org).balance).to eq Money.new(19000)
        end


      end

      context 'when the provider disputes the deposit' do
        before do
          job.reload.deposited_entries.last.dispute!
        end
        it 'billing status should be disputed' do
          expect(broker_job.reload.prov_collection_status_name).to eq :disputed
        end
        it 'billing status should be disputed' do
          expect(job.reload.subcon_collection_status_name).to eq :disputed
        end
        it 'deposit entry status should remain disputed' do
          expect(broker_job.reload.deposit_entries.last.status_name).to eq :disputed
        end

        it 'broker: account balance for prov should be 190.00 (the flat fee + bom reimb. - cash collection fee)' do
          expect(broker.account_for(org).balance).to eq Money.new(19000)
        end

      end



    end

    context 'when broker collects partially' do

      before do
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
        collect_a_payment broker_job, amount: 100, type: 'cash', collector: broker
        broker_job.collection_entries.last.deposit!

      end

      it 'broker job: prov collection status should be is_deposited' do
        expect(broker_job.reload.prov_collection_status_name).to eq :is_deposited
      end

      it 'prov job: subcon collection status should be is_deposited' do
        expect(job.reload.subcon_collection_status_name).to eq :is_deposited
      end

      it 'broker: account balance for prov should be -1.00 (the cash collection fee)' do
        expect(broker.account_for(org).balance).to eq Money.new(-100)
      end

      context 'when the broker collect another payment' do
        before do
          collect_a_payment broker_job, amount: 100, type: 'cash', collector: broker
        end
        it 'billing status should be is_deposited' do
          expect(broker_job.reload.prov_collection_status_name).to eq :partially_collected
        end
        it 'billing status should be is_deposited' do
          expect(job.reload.subcon_collection_status_name).to eq :partially_collected
        end

        it 'broker: account balance for prov should be -102.00 ($2 is the cash collection fee)' do
          expect(broker.account_for(org).balance).to eq Money.new(-10200)
        end


      end

      context 'when the provider confirms the deposit' do
        before do
          job.reload.deposited_entries.last.confirm!
        end
        it 'billing status should be deposited' do
          expect(broker_job.reload.prov_collection_status_name).to eq :deposited
        end
        it 'billing status should be deposited' do
          expect(job.reload.subcon_collection_status_name).to eq :deposited
        end
        it 'deposit entry status should be confirmed' do
          expect(broker_job.reload.deposit_entries.last.status_name).to eq :confirmed
        end

        it 'broker: account balance for prov should be -1.00 (the cash collection fee)' do
          expect(broker.account_for(org).balance).to eq Money.new(-100)
        end


      end

      context 'when the provider disputes the deposit' do
        before do
          job.reload.deposited_entries.last.dispute!
        end
        it 'billing status should be disputed' do
          expect(broker_job.reload.prov_collection_status_name).to eq :disputed
        end
        it 'billing status should be disputed' do
          expect(job.reload.subcon_collection_status_name).to eq :disputed
        end
        it 'deposit entry status should remain disputed' do
          expect(broker_job.reload.deposit_entries.last.status_name).to eq :disputed
        end

        it 'broker: account balance for prov should be -1.00 (the cash collection fee)' do
          expect(broker.account_for(org).balance).to eq Money.new(-100)
        end

      end

    end

    context 'when subcon collects fully' do
      before do
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
        collect_a_payment subcon_job, amount: 1000, type: 'cash', collector: subcon
        complete_the_work subcon_job
        subcon_job.reload.collection_entries.last.deposit!
        broker_job.reload
        subcon_job.reload
        job.reload
      end

      it 'broker job: prov collection status should be collected' do
        expect(broker_job.prov_collection_status_name).to eq :collected
      end

      it 'broker job: subcon collection status should be is_deposited' do
        expect(broker_job.subcon_collection_status_name).to eq :is_deposited
      end

      it 'subcon job: provider collection status should be is_deposited' do
        expect(subcon_job.prov_collection_status_name).to eq :is_deposited
      end

      it 'prov job: subcon collection status should be collected' do
        expect(job.subcon_collection_status_name).to eq :collected
      end

      it 'broker: account balance for prov should be 190.00 (the flat fee + bom reimb. - cash collection fee)' do
        expect(broker.account_for(org).balance).to eq Money.new(19000-100000)
      end

      it 'broker: account balance for subcon should be 190.00 (the flat fee + bom reimb. - cash collection fee)' do
        expect(broker.account_for(subcon).balance).to eq Money.new(-19000)
      end

      it 'the broker can''t collect another payment' do
        expect(broker_job.reload.billing_status_events).to eq []
      end

      it 'the subcon can''t collect another payment' do
        expect(subcon_job.reload.billing_status_events).to eq []
      end

      context 'when the provider confirms the deposit' do
        before do
          broker_job.reload.deposited_entries.last.confirm!
          broker_job.reload
          subcon_job.reload
          job.reload
        end
        it 'broker job: prov collection status should be is_deposited' do
          expect(broker_job.prov_collection_status_name).to eq :collected
        end

        it 'broker job: subcon collection status should be deposited' do
          expect(broker_job.subcon_collection_status_name).to eq :deposited
        end

        it 'subcon job: provider collection status should be is_deposited' do
          expect(subcon_job.prov_collection_status_name).to eq :deposited
        end

        it 'prov job: subcon collection status should be is_deposited' do
          expect(job.subcon_collection_status_name).to eq :collected
        end

        it 'broker: account balance for prov should be -810.00 (the flat fee + bom reimb. - cash collection fee)' do
          expect(broker.account_for(org).balance).to eq Money.new(10000 + 10000 -1000 - 100000)
        end

        it 'broker: account balance for subcon should be -190.00 (the flat fee + bom reimb. - cash collection fee)' do
          expect(broker.account_for(subcon).balance).to eq Money.new(-(10000 + 10000 -1000))
        end


      end

      context 'when the provider disputes the deposit' do

        before do
          broker_job.reload.deposited_entries.last.dispute!
          broker_job.reload
          subcon_job.reload
          job.reload
        end

        it 'broker job: prov collection status should be is_deposited' do
          expect(broker_job.prov_collection_status_name).to eq :collected
        end

        it 'broker job: subcon collection status should be disputed' do
          expect(broker_job.subcon_collection_status_name).to eq :disputed
        end

        it 'subcon job: provider collection status should be disputed' do
          expect(subcon_job.prov_collection_status_name).to eq :disputed
        end

        it 'prov job: subcon collection status should be is_deposited' do
          expect(job.subcon_collection_status_name).to eq :collected
        end

        it 'broker: account balance for prov should be -810.00 (the flat fee + bom reimb. - cash collection fee)' do
          expect(broker.account_for(org).balance).to eq Money.new(10000 + 10000 -1000 - 100000)
        end

        it 'broker: account balance for subcon should be -190.00 (the flat fee + bom reimb. - cash collection fee)' do
          expect(broker.account_for(subcon).balance).to eq Money.new(-(10000 + 10000 -1000))
        end

      end



    end

    context 'when subcon collects partially' do

        before do
          accept_the_job subcon_job
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
          collect_a_payment subcon_job, amount: 100, type: 'cash', collector: subcon
          complete_the_work subcon_job
          subcon_job.reload.collection_entries.last.deposit!
          broker_job.reload
          subcon_job.reload
          job.reload
        end

        it 'broker job: prov collection status should be partially_collected' do
          expect(broker_job.prov_collection_status_name).to eq :partially_collected
        end

        it 'broker job: subcon collection status should be is_deposited' do
          expect(broker_job.subcon_collection_status_name).to eq :is_deposited
        end

        it 'subcon job: provider collection status should be is_deposited' do
          expect(subcon_job.prov_collection_status_name).to eq :is_deposited
        end

        it 'prov job: subcon collection status should be partially_collected' do
          expect(job.subcon_collection_status_name).to eq :partially_collected
        end

        it 'broker: account balance for prov should be 190.00 (the flat fee + bom reimb. - cash collection fee - collection)' do
          expect(broker.account_for(org).balance).to eq Money.new(10000 + 10000 - 100 - 10000)
        end

        it 'broker: account balance for subcon should be 190.00 (the flat fee + bom reimb. - cash collection fee)' do
          expect(broker.account_for(subcon).balance).to eq Money.new(-10000 - 10000 + 100)
        end

        it 'the broker can''t collect another payment' do
          expect(broker_job.reload.billing_status_events).to eq [:collect]
        end

        it 'the subcon can''t collect another payment' do
          expect(subcon_job.reload.billing_status_events).to eq [:collect]
        end

        context 'when the provider confirms the deposit' do
          before do
            broker_job.reload.deposited_entries.last.confirm!
            broker_job.reload
            subcon_job.reload
            job.reload
          end
          it 'broker job: prov collection status should be partially_collected' do
            expect(broker_job.prov_collection_status_name).to eq :partially_collected
          end

          it 'broker job: subcon collection status should be deposited' do
            expect(broker_job.subcon_collection_status_name).to eq :deposited
          end

          it 'subcon job: provider collection status should be deposited' do
            expect(subcon_job.prov_collection_status_name).to eq :deposited
          end

          it 'prov job: subcon collection status should be partially_collected' do
            expect(job.subcon_collection_status_name).to eq :partially_collected
          end

          it 'broker: account balance for prov should be -810.00 (the flat fee + bom reimb. - cash collection fee - collection)' do
            expect(broker.account_for(org).balance).to eq Money.new(10000 + 10000 -100 - 10000)
          end

          it 'broker: account balance for subcon should be -190.00 (the flat fee + bom reimb. - cash collection fee)' do
            expect(broker.account_for(subcon).balance).to eq Money.new(-10000 -10000 + 100)
          end


        end

        context 'when the provider disputes the deposit' do

          before do
            broker_job.reload.deposited_entries.last.dispute!
            broker_job.reload
            subcon_job.reload
            job.reload
          end

          it 'broker job: prov collection status should be partially_collected' do
            expect(broker_job.prov_collection_status_name).to eq :partially_collected
          end

          it 'broker job: subcon collection status should be disputed' do
            expect(broker_job.subcon_collection_status_name).to eq :disputed
          end

          it 'subcon job: provider collection status should be disputed' do
            expect(subcon_job.prov_collection_status_name).to eq :disputed
          end

          it 'prov job: subcon collection status should be partially_collected' do
            expect(job.subcon_collection_status_name).to eq :partially_collected
          end

          it 'broker: account balance for prov should be -810.00 (the flat fee + bom reimb. - cash collection fee - collection)' do
            expect(broker.account_for(org).balance).to eq Money.new(10000 + 10000 -100 - 10000)
          end

          it 'broker: account balance for subcon should be -190.00 (the flat fee + bom reimb. - cash collection fee)' do
            expect(broker.account_for(subcon).balance).to eq Money.new(-10000 -10000 +100)
          end

        end

    end
  end

end