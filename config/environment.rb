# Load the rails application
require File.expand_path('../application', __FILE__)
Date::DATE_FORMATS.merge!(:default => "%d/%m/%y")

# Initialize the rails application
Sbcx::Application.initialize!
