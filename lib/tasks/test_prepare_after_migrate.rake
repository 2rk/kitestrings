namespace :db do
  task :migrate do
    Rake::Task["db:test:prepare"].invoke if Rails.env.development?
  end

  namespace :test do
    task :prepare do
      Rake::Task["db:fixtures:load"].invoke
    end
  end
end
