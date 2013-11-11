require 'spec_helper'

describe 'My behaviour', js: true do
  self.use_transactional_fixtures = false

  setup_org

  let(:app) { App.new }
  before do
    in_browser(:org) do
      sign_in org_admin_user
      app.job_page.load
    end
  end

  it 'should do something' do
    app.job_page.should be_displayed
    app.job_page.should have_job_status
  end
end