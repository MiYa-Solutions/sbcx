namespace :db do
  namespace :dev do
    task build: :environment do
      Rake::Task["db:reset"].invoke
      Rake::Task["db:seed"].invoke
      Rake::Task["db:populate"].invoke
    end
  end
end

namespace :db do
  namespace :test do
    task build: :environment do
      Rails.env = 'test'
      Rake::Task["db:test:prepare"].invoke
      Rake::Task["db:seed"].invoke
    end
  end
end

