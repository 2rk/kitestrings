require 'spec_helper'
require 'fileutils'
require 'generator_spec'
require 'generators/kitestrings/install_generator'

describe Kitestrings::Generators::InstallGenerator do
  destination File.expand_path("../../../../tmp", __FILE__)

  before :all do
    prepare_destination
    run_generator
    @dir = self.class.test_case.destination_root
  end

  def file_path(path)
    File.join(@dir, path)
  end

  def file_contents(path)
    File.read(file_path(path))
  end

  context "check files" do
    %w[
        spec_ext/my_ip_spec.rb
        spec_ext/spec_helper_ext.rb
        config/deploy.rb
        config/deploy/integ.rb
        config/deploy/uat.rb
        config/deploy/production.rb
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
  ].each do |file|
      it "created #{file}" do
        path = File.join(@dir, file)
        expect(File.exist?(path)).to be_truthy
      end
    end
  end

  # otherwise it wants to run the specs in the tmp/spec directory
  after(:all) { rm_rf(@dir) }

end
