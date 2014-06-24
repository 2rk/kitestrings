require 'spec_helper'
require 'fileutils'
require 'generator_spec'
require 'generators/kitestrings/messages_generator'
require 'rails'

describe Kitestrings::Generators::MessagesGenerator do
  destination File.expand_path("../../../../tmp", __FILE__)

  before :all do
    prepare_destination
    run_generator
    @dir = self.class.test_case.destination_root
  end

  it do
    expect(File.exist?(File.join(@dir, "app/models/message.rb")))
  end
end
