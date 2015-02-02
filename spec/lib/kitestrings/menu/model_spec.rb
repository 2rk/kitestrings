require 'spec_helper'
require 'kitestrings/menu'
require 'kitestrings/menu/model'

describe Kitestrings::Menu::Model do
  let(:klass) { Class.new { include Kitestrings::Menu::Model } }
  subject { klass.new }

  context "Class" do
    it "uses activemodel::naming" do
      klass.class_eval do
        self.extend ActiveModel::Naming
        def self.name
          "example"
        end
      end
      expect(klass.menu_display_name).to eq("Examples")
    end
  end

  context "Instance" do
    it "default name method" do
      subject.stub(:name => "some example")
      expect(subject.menu_display_name).to eq("some example")
    end

    it "explicit name method" do
      klass.menu_name_method = :full_name
      subject.stub(:full_name => "full name example")
      expect(subject.menu_display_name).to eq("full name example")
    end
  end
end
