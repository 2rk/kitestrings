require 'spec_helper'
require 'active_support'
require 'active_model'
require 'count_validator'

class CountValidatorThing
  include ActiveModel::Validations
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  validates :items, count: {min: 1, max: 5}
end

describe CountValidator do

  before { subject.valid? }

  context "validating an object with no items" do
    subject { CountValidatorThing.new(nil) }
    it { expect(subject.errors[:items]).to include("must be countable") }
  end

  context "validating an object with an empty array" do
    subject { CountValidatorThing.new([])}
    it { expect(subject.errors[:items]).to include("must have at least 1 item") }
  end

  context "validating an object with an empty array" do
    subject { CountValidatorThing.new([1,2,3,4,5,6])}
    it { expect(subject.errors[:items]).to include("must have at most 5 items") }
  end

  context "validation passes" do
    subject { CountValidatorThing.new([1,2,3])}
    it { expect(subject.errors[:items]).to be_empty }
  end
end
