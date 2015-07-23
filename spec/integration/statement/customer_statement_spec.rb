require 'spec_helper'

describe 'Customer Statement' do

  include_context 'basic job testing'
  let(:statement) { job.customer.account.statements.build }
  let(:job2) { FactoryGirl.build(:job, organization: org, customer: job.customer) }

  before do
    start_the_job job
    add_bom_to_job job, price: 100, cost: 10, quantity: 1
    complete_the_work job

    start_the_job job2
    add_bom_to_job job2, price: 100, cost: 10, quantity: 1
    complete_the_work job2

  end

  context 'when creating the statement' do
    before do
      statement.save(StatementSerializer::CustomerStatementSerializer)
    end

    it 'should geerate a valid statemenet' do
      expect(statement).to be_valid
    end

    it 'statement balance should be correct' do
      expect(statement.balance).to eq Money.new(20000)
    end
  end

  context 'when creating the statement with notes' do
    before do
      statement.notes = 'THE NOTES'
      statement.save(StatementSerializer::CustomerStatementSerializer)
    end

    it 'should geerate a valid statemenet' do
      expect(statement.reload.notes).to eq 'THE NOTES'
    end

  end

  describe 'when creating the statement with exclusion of 0 balance jobs' do
    context 'when creating a third job' do
      let(:job3) { FactoryGirl.build(:job, organization: org, customer: job.customer) }
      before do
        job3.save!
        job3.customer.account.entries << AdvancePayment.new(amount: Money.new(10000), ticket: job3, description: 'test')
        job3.reload
        invoice job3
        job3.reload
        collect_a_payment job3, amount: 100, type: 'cash'
        job3.reload
      end

      context 'when creating the statement without excluding zero balance' do
        before do
          statement.exclude_zero_balance = false
          statement.save(StatementSerializer::CustomerStatementSerializer)
        end

        it 'should have 3 tickets ' do
          expect(statement.tickets.size).to eq 3
        end
      end
      context 'when creating the statement excluding zero balance' do
        before do
          statement.exclude_zero_balance = true
          statement.save(StatementSerializer::CustomerStatementSerializer)
        end

        it 'should have 3 tickets ' do
          expect(statement.tickets.size).to eq 2
        end
      end
    end
  end

  context 'when creating a third job' do
    let(:job3) { FactoryGirl.build(:job, organization: org, customer: job.customer) }
    before do
      job3.save!
    end

    context 'when creating the statement' do
      before do
        statement.save(StatementSerializer::CustomerStatementSerializer)
      end
      it 'statement should have 2 tickets ' do
        expect(statement.tickets.size).to eq 2
      end
    end

    context 'when completing the job' do

      before do
        start_the_job job3
        add_bom_to_job job3, price: 100, quantity: 1
        complete_the_work job3
      end

      context 'when creating the statement' do
        before do
          statement.save(StatementSerializer::CustomerStatementSerializer)
        end

        it 'statement should have 3 tickets ' do
          expect(statement.tickets.size).to eq 3
        end
      end

      context 'when collecting the full payment' do
        before do
          collect_full_amount job3
          job3.reload.entries.last.deposit!
          job3.reload
        end

        context 'when creating the statement' do
          before do
            statement.save(StatementSerializer::CustomerStatementSerializer)
          end

          it 'statement should have 2 tickets ' do
            expect(statement.tickets.size).to eq 2
          end

        end

        context 'when assigning an adjustment entry to the job and customer account' do

          before do
            create_adj_entry_for_ticket job3.customer.account, 10, job3
          end

          context 'when creating the statement' do

            before do
              job3.reload
              statement.save(StatementSerializer::CustomerStatementSerializer)
            end

            it 'statement should have 3 tickets ' do
              expect(statement.tickets.size).to eq 3
            end
          end

          context 'when creating the counter adjustment' do
            before do
              create_adj_entry_for_ticket job3.customer.account, -10, job3
            end
            context 'when creating the statement' do

              before do
                job3.reload
                statement.save(StatementSerializer::CustomerStatementSerializer)
              end

              it 'statement should have 2 tickets ' do
                expect(statement.tickets.size).to eq 2
              end
            end

          end

        end

      end
    end


    context 'when creating the statement without excluding zero balance' do
      before do
        statement.exclude_zero_balance = false
        statement.save(StatementSerializer::CustomerStatementSerializer)
      end

      it 'should have 3 tickets ' do
        expect(statement.tickets.size).to eq 3
      end
    end
    context 'when creating the statement excluding zero balance' do
      before do
        statement.exclude_zero_balance = true
        statement.save(StatementSerializer::CustomerStatementSerializer)
      end

      it 'should have 3 tickets ' do
        expect(statement.tickets.size).to eq 2
      end
    end
  end


end