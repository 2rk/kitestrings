require 'spec_helper'
require 'active_support'
require 'active_model'
require 'size_validator'

class SizeValidatorThing
  include ActiveModel::Validations
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  validates :items, size: {min: 1, max: 5}
end

describe SizeValidator do

  before { subject.valid? }

  context "validating an object with no items" do
    subject { SizeValidatorThing.new(nil) }
    it { expect(subject.errors[:items]).to include("must be sizeable") }
  end

  context "validating an object with an empty array" do
    subject { SizeValidatorThing.new([])}
    it { expect(subject.errors[:items]).to include("must have at least 1 item") }
  end

  context "validating an object with an empty array" do
    subject { SizeValidatorThing.new([1,2,3,4,5,6])}
    it { expect(subject.errors[:items]).to include("must have at most 5 items") }
  end

  context "validation passes" do
    subject { SizeValidatorThing.new([1,2,3])}
    it { expect(subject.errors[:items]).to be_empty }
  end
end
