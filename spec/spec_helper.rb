require File.expand_path("../../config/environment", __FILE__)
require 'rubygems'
#require 'spork'
require 'rspec/rails'
#require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'declarative_authorization/maintenance'

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :debug => true)
end

Capybara.ignore_hidden_elements = false

ENV["RAILS_ENV"] = 'test'

include Authorization::TestHelper


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
RSpec.configure do |config|

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
  config.include Capybara::DSL
  #config.include Capybara::RSpecMatchers


  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation

  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    load "#{Rails.root}/db/seeds.rb"
  end
end





