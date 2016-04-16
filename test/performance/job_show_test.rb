require 'test_helper'
require 'rails/performance_test_help'

class JobShowTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 5, :metrics => [:wall_time, :process_time, :memory, :objects, :gc_runs, :gc_time],
                           :output => 'tmp/performance', :formats => [:flat, :graph_html, :call_tree, :call_stack] }
  include Warden::Test::Helpers
  include FactoryGirl::Syntax::Methods
  Warden.test_mode!

  def setup
    @user = User.find_by_email('markmilman@gmail.com')
    login_as @user, scope: :user
    @job = @user.organization.tickets.where(status: Ticket::STATUS_CLOSED).last
  end

  def teardown
    Warden.test_reset!
  end

  def test_job_index
    get "/service_calls/#{@job.id}"
  end

end
