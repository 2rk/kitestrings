require 'rails'
require 'rails/generators'

module Kitestrings
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies 2rk relevant templates to the relevant directory"

      def copy_config_files
        copy_file "config/deploy.rb", "config/deploy.rb"
        directory "config/deploy", "config/deploy"
        directory "config/environments", "config/environments"
      end

      def copy_haml_files
        directory "haml", "lib/templates/haml"
      end

      def copy_scaffold_files
        directory "rails", "lib/templates/rails"
      end

      def copy_rspec_files
        directory "rspec", "lib/templates/rspec"
      end

      def copy_spec_files
        directory "spec", "lib/templates/spec"
      end

      def copy_spec_support_files
        directory "support", "spec/support/render_views"
      end

      def copy_spec_ext
        directory "spec_ext", "spec_ext"
      end

      def copy_app_view_files
        copy_file "views/application/_navigation.html.haml", "app/views/application/_navigation.html.haml"
        copy_file "views/layouts/application.html.haml", "app/views/layouts/application.html.haml"
        copy_file "views/public/403.html", "app/views/public/403.html"
      end

      def setup_application_controller
        inject_into_file "app/controllers/application_controller.rb", :after => /protect_from_forgery.*$/ do
          <<-EOF


  unless Rails.application.config.consider_all_requests_local
    rescue_from CanCan::AccessDenied do |exception|
      # Notify errbit if you would like to:
      # Airbrake.notify(exception)
      render 'public/403', status: 403, layout: 'none'
    end
  end
          EOF
        end
      end

      def setup_directories
        empty_directory("lib/capistrano")
        create_file("lib/capistrano/.keep")
      end
    end
  end
end
