require 'test_helper'

class MyTest < ActionDispatch::IntegrationTest

  include Warden::Test::Helpers
  Warden.test_mode!

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @user = User.find_by_email('markmilman@gmail.com')
    login_as @user, scope: :user
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    Warden.test_reset!
  end

  # Fake test
  def test_login

    get service_calls_path
    assert_equal 200, status

  end


end