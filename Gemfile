source 'http://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.22.1'
gem 'jquery-rails', '2.1.4'
gem 'jquery_mobile_rails', '1.2.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.4.3'
gem 'will_paginate', '3.0.5'
gem 'bootstrap-will_paginate', '0.0.5'
gem 'bootstrap-datepicker-rails', '1.3.0.2'
gem 'carmen', '1.0.0.beta2'
gem 'carmen-rails', '1.0.0.beta3'
gem 'active_attr', '0.8.1'
gem 'newrelic_rpm'

gem 'american_date', '1.0.0'

gem 'pg', '0.17.1'
gem 'activerecord-postgres-hstore', '0.7.5'

gem 'devise', '~> 3.4.1'
gem 'simple_form', '2.0.2'
gem 'declarative_authorization', '0.5.7'

gem 'state_machine', '1.1.2'
gem 'magiclabs-userstamp', '2.0.2'
gem 'strong_parameters', '0.2.3'
gem 'paper_trail', '3.0.0'

gem 'best_in_place', git: 'git://github.com/MiYa-Solutions/best_in_place.git'
gem 'unicorn', '~> 4.8.0', platform: :ruby
gem 'figaro', '0.5.3' #for environment variable configuration
gem 'rails3-jquery-autocomplete', git: 'git://github.com/MiYa-Solutions/rails3-jquery-autocomplete.git'

gem 'monetize', '0.1.4'
gem 'money-rails', '0.9.0'
gem 'select2-rails', '3.3.1'
gem 'bootstrap-editable-rails', '0.0.4'
gem 'RedCloth', '~> 4.2.9', :require => 'redcloth'
gem 'rails3_acts_as_paranoid', '~> 0.2.5'
gem 'activeadmin', '0.6.6'
gem 'meta_search', '>= 1.1.0.pre'
gem 'prawn', '~> 0.13.1'
gem 'validates_email_format_of'

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'acts_as_commentable_with_threading'

gem 'roo'
gem 'simple_token_authentication', '~> 1.0'
gem 'active_model_serializers', '0.9.4'

group :production do
  gem 'rails_12factor'
end

group :development, :staging do
  gem 'letter_opener'
end

group :development do
  gem 'ruby-graphviz', :require => 'graphviz'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'heroku_san'
  gem 'metric_fu'
end

group :development, :test do
  gem 'rspec-rails', '2.13.0'
  gem 'annotate', '2.5.0'
  gem 'nifty-generators'
  gem 'quiet_assets'
  gem 'ruby_parser'
  gem 'thin', '1.6.3'
  gem 'debase', '~> 0.1.1'
  gem 'ruby-debug-ide'
  gem 'rack-mini-profiler'
end

group :profile do
  gem 'ruby-prof'
  gem 'test-unit'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
  gem 'jquery-datatables-rails', '3.1.1'
  gem 'jquery-ui-rails', '4.1.1'
  gem 'fullcalendar-rails', '1.5.4.0'
  gem 'sass-rails', '3.2.4'
  gem 'bootstrap-sass', '2.0.4'
  gem 'chosen-rails', '1.1.0'
  gem 'compass', '0.12.6'
  gem 'handlebars_assets', '0.18'
  gem 'parsley-rails'
  gem 'momentjs-rails'
  gem 'rails-bootstrap-daterangepicker'
end

group :test do
  gem 'capybara', '2.4.3'
  gem 'site_prism'
  gem 'factory_girl_rails', '4.1.0', require: false
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner', '~> 0.9.1'
  gem 'rb-fsevent', '0.9.1', require: RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'launchy', '2.1.0'
  gem 'mocha'
  gem 'capybara-screenshot', '0.3.4'
  gem 'poltergeist', '1.6.0'
  gem 'shoulda-matchers', require: false
  gem 'spork', '0.9.2'
  gem 'faye-websocket', '0.9.2'
  gem 'simplecov'
  gem 'rest-client', '~> 1.7.2'
  gem 'method_source'
  gem 'rspec_candy'
end