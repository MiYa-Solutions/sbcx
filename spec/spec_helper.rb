require 'simplecov'
SimpleCov.start

require File.expand_path("../../config/environment", __FILE__)
require 'rubygems'
require 'spork'
require 'rspec/rails'
require 'shoulda/matchers'
require 'rspec/autorun'
require 'declarative_authorization/maintenance'
require 'money-rails/test_helpers'
require 'active_attr/rspec'
require 'factory_girl_rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'site_prism'
require 'devise'
require 'rspec_candy/all'
require 'ext/string'



#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'


Spork.prefork do

  include Warden::Test::Helpers
  Warden.test_mode!
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  #require 'factory_girl_rails'
  Capybara.javascript_driver = :poltergeist

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, :debug => true) #, :js_errors => false)
  end

  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end


  Capybara.ignore_hidden_elements = false
  Capybara.save_and_open_page_path = "./tmp/capybara"

  ENV["RAILS_ENV"] ||= 'test'

  include Authorization::TestHelper
  include MoneyRails::TestHelpers

  # this is to eager load models properly
  Spork.trap_method(Rails::Application, :reload_routes!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  #Spork.trap_method(Rails::ActiveRecord, :load_models)

  Spork.trap_method(Rails::Application, :eager_load!)

  require File.expand_path("../../config/environment", __FILE__)

  Rails.application.railties.all { |r| r.eager_load! }
  #
  #
  #Spork.trap_class_method(FactoryGirl, :find_definitions)
  #
  #require File.expand_path(File.dirname(__FILE__) + '/../config/environment')


  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  require "#{Rails.root}/spec/support/pages/sbcx_page.rb"
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
  full_names = Dir["#{Rails.root}/app/helpers/*.rb"]
  full_names.collect do |full_name|
    include Object.const_get(File.basename(full_name,'.rb').camelize)
  end

  RSpec.configure do |config|

    # config.around(:each, type: [:feature, :request]) do |ex|
    #   example = RSpec.current_example
    #   CAPYBARA_TIMEOUT_RETRIES.times do |i|
    #     example.instance_variable_set('@exception', nil)
    #     self.instance_variable_set('@__memoized', nil) # clear let variables
    #     ex.run
    #     break unless example.exception.is_a?(Capybara::Poltergeist::TimeoutError)
    #     puts("\nCapybara::Poltergeist::TimeoutError at #{example.location}\n   Restarting phantomjs and retrying...")
    #     restart_phantomjs
    #   end
    # end
    #
    #config.filter_run :focus => true
    #config.run_all_when_everything_filtered = true

    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures                 = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
    config.include(Matchers)
    config.include(ServiceCallMatchers)
    config.include(AccountingMatchers)
    config.include(AccountingEntryMatchers)
    config.include Capybara::DSL
    #config.include Capybara::RSpecMatchers
    config.include Devise::TestHelpers, type: :controller

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation

    end

    config.before(:each, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
      load "#{Rails.root}/db/seeds.rb"
    end
    ActiveSupport::Dependencies.clear

    config.alias_it_should_behave_like_to :it_should, 'it should:'

  end
end

Spork.each_run do
  #FactoryGirl.reload
  #Dir["#{Rails.root}/app/models/**/*.rb"].each do |model|
  #  load model unless model == "/Users/mark/RubymineProjects/sbcx/app/models/permitted_params.rb"
  #end
  Warden.test_reset!

  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  #FactoryGirl.factories.clear
  # reload all the models
  Dir["#{Rails.root}/app/models/concerns/*.rb"].each do |model|
    require model
  end
  Dir["#{Rails.root}/app/exceptions/**/*.rb"].each do |model|
    require model
  end
  Dir["#{Rails.root}/app/models/**/*.rb"].each do |model|
    load model unless model.include? 'permitted_params'
  end
  Dir["#{Rails.root}/app/models/accounting_entries/*.rb"].each do |model|
    load model
  end
  Dir["#{Rails.root}/app/events/**/*.rb"].each do |model|
    load model
  end
  Dir["#{Rails.root}/app/observers/**/*.rb"].each do |model|
    load model
  end
  #Dir["#{Rails.root}/app/services/**/*.rb"].each do |model|
  #  load model
  #end
  #Dir["#{Rails.root}/app/notifications/**/*.rb"].each do |model|
  #  load model
  #end
  Dir["#{Rails.root}/spec/support/**/*.rb"].each do |model|
    load model
  end
end

def restart_phantomjs
  puts "-> Restarting phantomjs: iterating through capybara sessions..."
  session_pool = Capybara.send('session_pool')
  session_pool.each do |mode,session|
    msg = "  => #{mode} -- "
    driver = session.driver
    if driver.is_a?(Capybara::Poltergeist::Driver)
      msg += "restarting"
      driver.restart
    else
      msg += "not poltergeist: #{driver.class}"
    end
    puts msg
  end
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.

  
