source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'jquery-rails'
gem 'bootstrap-sass', '2.0.4'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.5'
gem 'bootstrap-datepicker-rails'
gem 'carmen-rails', '~> 1.0.0.beta3'

gem 'pg'

gem 'devise', '2.0.0'
gem 'simple_form', '2.0.2'
gem 'declarative_authorization', '0.5.5'

gem 'state_machine'
gem 'magiclabs-userstamp'
gem 'strong_parameters'

gem 'best_in_place'

group :development do
  gem 'thin'
  gem 'ruby-graphviz', :require => 'graphviz'
end
group :development, :test do
  gem 'rspec-rails', '2.9.0'
  gem 'guard-rspec', '0.5.5'
  gem 'annotate', '~> 2.4.1.beta'
  gem 'nifty-generators'
  gem 'quiet_assets'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.4'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
  gem 'jquery-ui-rails'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '1.4.0'
  gem 'cucumber-rails', '1.2.1', require: false
  gem 'database_cleaner', '0.7.0'
  gem 'rb-fsevent', '0.9.1', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl', '1.0.3'
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  gem 'launchy', '2.1.0'
  gem 'mocha'
  gem 'capybara-screenshot'
  gem 'poltergeist'
end

group :production do
end
