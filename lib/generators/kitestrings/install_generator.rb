require 'rails'
require 'rails/generators'

module Kitestrings
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies 2rk relevant templates to the relevant directory"

      def copy_deploy
        copy_file "deploy.rb", "config/deploy.rb"
      end

      def copy_deploy_files
        directory "deploy", "config/deploy"
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

      def copy_app_view_files
        directory "views", "app/views"
      end
    end
  end
end