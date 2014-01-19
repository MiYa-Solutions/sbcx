source 'http://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.16'
gem 'jquery-rails', '2.1.4'
gem 'jquery_mobile_rails', '1.2.0'
gem 'bootstrap-sass', '2.0.4'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.5'
gem 'bootstrap-will_paginate', '0.0.5'
gem 'bootstrap-datepicker-rails', '1.0.0'
gem 'carmen', '1.0.0.beta2'
gem 'carmen-rails', '1.0.0.beta3'
gem 'active_attr', '0.7.0'
gem 'newrelic_rpm'

gem 'american_date', '1.0.0'

gem 'pg', '0.17.1'
gem 'activerecord-postgres-hstore', '0.7.5'

gem 'devise', '2.0.0'
gem 'simple_form', '2.0.2'
gem 'declarative_authorization', '0.5.5'

gem 'state_machine', '1.1.2'
gem 'magiclabs-userstamp', '2.0.2'
gem 'strong_parameters', '0.2.0'
gem 'paper_trail', '~> 3.0.0'

gem 'best_in_place', git: 'git://github.com/MiYa-Solutions/best_in_place.git'
gem 'unicorn', '~> 4.8.0'
gem 'figaro', '0.5.3' #for environment variable configuration
gem 'rails3-jquery-autocomplete', git: 'git://github.com/MiYa-Solutions/rails3-jquery-autocomplete.git'

gem 'money-rails'
gem 'select2-rails', '3.3.1'
gem 'bootstrap-editable-rails', '0.0.4'
gem 'RedCloth', '~> 4.2.9', :require => 'redcloth'
gem 'rails3_acts_as_paranoid', '~> 0.2.5'
gem 'activeadmin'
gem 'meta_search', '>= 1.1.0.pre'
gem 'prawn', '~> 0.13.1'
gem 'rails_12factor'
gem 'queue_classic', '2.2.3'

group :development do
  gem 'ruby-graphviz', :require => 'graphviz'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'letter_opener'
end
group :development, :test do
  gem 'rspec-rails', '2.13.0'
  gem 'annotate', '2.5.0'
  gem 'nifty-generators'
  gem 'quiet_assets'
  gem 'ruby_parser'

end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
  gem 'jquery-datatables-rails'
  gem 'jquery-ui-rails', '4.1.1'
  gem 'fullcalendar-rails', '1.5.4.0'
end

group :test do
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.1.0', require: false
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner', '~> 0.9.1'
  gem 'rb-fsevent', '0.9.1', require: RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'launchy', '2.1.0'
  gem 'mocha'
  gem 'capybara-screenshot', '0.3.4'
  gem 'poltergeist', '1.4.1'
  gem 'shoulda'
  gem 'spork', '0.9.2'
  gem 'faye-websocket', '0.4.4'
end