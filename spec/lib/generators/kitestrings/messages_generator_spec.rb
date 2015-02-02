require 'spec_helper'
require 'fileutils'
require 'generator_spec'
require 'generators/kitestrings/messages_generator'
require 'rails'

describe Kitestrings::Generators::MessagesGenerator do

  include GeneratorSupport

  destination File.expand_path("../../../../../tmp", __FILE__)

  before :all do
    prepare_destination
    run_rails_new_generator(destination_root)
    run_generator
    @dir = self.class.test_case.destination_root
  end

  context "check files" do
    %w[
        app/controllers/messages_controller.rb
        app/models/message.rb
        app/mailers/message_mailer.rb
        app/views/message_mailer/default.text.erb
        app/views/messages/index.html.haml
        app/views/messages/show.html.haml
        spec/controllers/messages_controller_spec.rb
        spec/models/message_spec.rb
        spec/factories/messages.rb
    ].each do |file|
      it "created #{file}" do
        path = file_path(file)
        expect(File.exist?(path)).to be_truthy
      end

      it "created a migration" do
        files = Dir.glob(file_path("/db/migrate/*.rb"))
        expect(files.select { |name| File.basename(name) =~ /create_messages/ }.count).to eq(1)
      end

      it "updated the routes" do
        expect(file_contents("config/routes.rb")).to include('resources :messages, only: [:index, :show]')
      end
    end
  end
end
