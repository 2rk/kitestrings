require 'kitestrings'
require 'rails'
module Kitestrings
  class Railtie < ::Rails::Railtie
    railtie_name :kitestrings

    rake_tasks do
      load "tasks/test_prepare_after_migrate.rake"
    end
  end
end