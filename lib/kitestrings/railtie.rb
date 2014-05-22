module Kitestrings
  module Rails
    class Railtie < ::Rails::Railtie
      config.generators do |g|
        g.templates.unshift File::expand_path('../../templates', __FILE__)
      end
    end
  end
end