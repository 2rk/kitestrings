require 'rails'
require 'rails/generators'

module Kitestrings
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copies 2rk relevant templates to the relevant directory"

      def copy_config_files
        directory "config", "config", :recursive => false
      end

      def copy_seeds_file
        copy_file "db/seeds.rb", "db/seeds.rb"
      end

      def copy_rubocop_file
        copy_file "rubocop/.rubocop.yml", ".rubocop.yml"
        directory "rubocop/routing", "spec/routing"
      end

      def copy_haml_files
        directory "haml", "lib/templates/haml"
      end

      def copy_scaffold_files
        directory "rails", "lib/templates/rails"
      end

      def copy_lib_files
        directory "lib", "lib"
      end

      def copy_rspec_files
        directory "rspec", "lib/templates/rspec"
      end

      def copy_spec_files
        copy_file "spec/rails_helper.rb", "spec/rails_helper.rb"
      end

      def copy_spec_support_files
        directory "support", "spec/support"
      end

      def copy_rake_task_files
        directory "tasks", "lib/tasks"
      end

      def copy_app_view_files
        copy_file "views/application/_navigation.html.haml", "app/views/application/_navigation.html.haml"
        copy_file "views/layouts/application.html.haml", "app/views/layouts/application.html.haml"
        copy_file "views/public/403.html", "app/views/public/403.html"
      end

      # def setup_abilities_with_default_role
      #   inject_into_file "app/models/ability.rb" do #, :after => /def initialize(user).*$/ do
      #     "\n"\
      #     "    case user.role\n"\
      #     "      when :default\n"\
      #     "        can :manage, :all\n"\
      #     "    end\n"\
      #
      #   end
      # end

      def setup_abilities_with_default_role
        insert_into_file "app/models/ability.rb", :after => "def initialize(user)" do
          "\n"\
          "    case user.role\n"\
          "      when :default\n"\
          "        can :manage, :all\n"\
          "    end\n"\

        end
      end

      def setup_application_controller
        inject_into_file "app/controllers/application_controller.rb", :after => /protect_from_forgery.*$/ do
"
  respond_to :html
  include NestedLoadAndAuthorize

  unless Rails.application.config.consider_all_requests_local
    rescue_from CanCan::AccessDenied do |exception|
      # Notify errbit if you would like to:
      # Airbrake.notify(exception)
      render 'public/403', status: 403, layout: 'none'
    end
  end"
        end
      end


      def setup_application_config
        generators_configuration = <<-END
config.generators do |g|
      g.view_specs false
      g.test_framework :rspec, fixture: true
    end

    config.app_generators do |g|
      g.templates.unshift File.expand_path('../lib/templates', __FILE__)
    end

    config.autoload_paths += %W(\#{config.root}/lib)
        END

        environment generators_configuration
      end

    end
  end
end
