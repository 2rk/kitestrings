require "bundler/gem_tasks"

require 'rspec/core/rake_task'

desc "Run the specs."
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

task :default => [:spec]
