Rake::Task['db:fixtures:load'].invoke
Rake::Task['tmp:clear'].invoke unless ENV['RAILS_ENV'] == 'test'
