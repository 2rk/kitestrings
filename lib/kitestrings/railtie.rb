require 'kitestrings'
require 'rails'
module Kitestrings
  class Railtie < ::Rails::Railtie
    railtie_name :kitestrings

    initializer 'kitestrings.autoload', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << File.expand_path("../../", __FILE__)
    end
  end
end
