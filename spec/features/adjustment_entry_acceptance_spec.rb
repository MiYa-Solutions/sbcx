require 'spec_helper'
require_relative '../../spec/features/acceptance_testing_shared_stuff'

describe 'Adjustment Entry Acceptance', js: true do
  self.use_transactional_fixtures = false

  include_context 'acceptance tests with two members', :create_profit_split_agreement, {}
  include_context 'create job and transfer to org2'

  before do
    in_browser(:org2) do
      complete_job subcon_job
    end
  end

  it 'job completion should be succesfull' do
    expect(page).to have_success_message
  end

  it 'should create adjustment entry successfully' do
    in_browser(:org) do
      visit accounting_entries_path
      select2_select

    end
    expect(page).to have_success_message
  end
end