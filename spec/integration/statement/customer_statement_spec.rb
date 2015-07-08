require 'spec_helper'

describe 'Customer Statement' do

  include_context 'basic job testing'

  before do
    start_the_job job
    add_bom_to_job job, price: 100, cost: 10, quantity: 1
    complete_the_work job
  end

  context 'when creating the statement' do
    let(:statement) { job.customer.account.statements.build }
    let(:job2) { FactoryGirl.build(:job, organization: org, customer: job.customer) }
    before do
      start_the_job job2
      add_bom_to_job job2, price: 100, cost: 10, quantity: 1
      complete_the_work job2
      statement.save(StatementSerializer::CustomerStatementSerializer)
    end

    it 'should geerate a valid statemenet' do
      expect(statement).to be_valid
    end
  end

end