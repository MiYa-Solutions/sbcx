namespace :deploy do
  task :staging, [:debug] => :environment do |t, args|
    args.with_defaults(:debug => 'true')
    Rake::Task["heroku:maintenance_on"].invoke(:staging)
    sleep 5
    Rake::Task["heroku:maintenance_off"].invoke(:staging)
  end
end
