# This file is used by Rack-based servers to start the application.
$stdout.sync = true
require ::File.expand_path('../config/environment',  __FILE__)
run Sbcx::Application

if Rails.env.profile?
  use Rack::RubyProf, :path => '/tmp/profile'
end
