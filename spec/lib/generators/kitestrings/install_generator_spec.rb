require 'spec_helper'
require 'fileutils'
require 'generator_spec'
require 'generators/kitestrings/install_generator'

describe Kitestrings::Generators::InstallGenerator do

  include GeneratorSupport

  destination File.expand_path("../../../../../tmp", __FILE__)

  before :all do
    prepare_destination
    run_rails_new_generator(destination_root)
    run_generator
  end

  context "check files" do
    %w[
        spec/rails_helper.rb
        config/deploy.rb
        config/deploy/integ.rb
        config/deploy/uat.rb
        config/deploy/production.rb
        config/environments/integ.rb
        config/environments/uat.rb
        lib/templates/haml/scaffold/_form.html.haml
        lib/templates/haml/scaffold/edit.html.haml
        lib/templates/haml/scaffold/index.html.haml
        lib/templates/haml/scaffold/new.html.haml
        lib/templates/haml/scaffold/show.html.haml
        lib/templates/rails/scaffold_controller/controller.rb
        lib/templates/rspec/helper/helper_spec.rb
        lib/templates/rspec/integration/request.rb
        lib/templates/rspec/model/model_spec.rb
        lib/templates/rspec/scaffold/controller_spec.rb
        lib/templates/rspec/scaffold/routing_spec.rb
        app/views/public/403.html
        app/views/layouts/application.html.haml
        app/views/application/_navigation.html.haml
  ].each do |file|
      it "created #{file}" do
        path = file_path(file)
        expect(File.exist?(path)).to be_truthy
      end
    end
  end

  it "inserted into application_controller" do
    file_contents("app/controllers/application_controller.rb").should match(/rescue_from CanCan::AccessDenied/)
  end

  # otherwise it wants to run the specs in the tmp/spec directory
  after(:all) { rm_rf(destination_root) }
end
