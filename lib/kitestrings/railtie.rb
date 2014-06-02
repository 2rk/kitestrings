require 'kitestrings'
require 'rails'
module Kitestrings
  class Railtie < ::Rails::Railtie
    railtie_name :kitestrings

    rake_tasks do
      load "tasks/test_prepare_after_migrate.rake"
    end

    initializer 'kitestrings.autoload', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << File.expand_path("../../", __FILE__)
    end
  end
end
