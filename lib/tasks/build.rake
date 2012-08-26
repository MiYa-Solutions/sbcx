namespace :db do
  namespace :dev do
    task build: :environment do
      Rake::Task["db:reset"].invoke
      Rake::Task["db:seed"].invoke
      Rake::Task["db:populate"].invoke
    end
  end
end
