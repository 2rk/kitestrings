require 'rails_helper'
require 'active_support'
require 'active_model'
require 'array_validator'

class ThingWithItems
  include ActiveModel::Validations
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  validates :items, array: {min: 1, max: 5}
end

describe ArrayValidator do

  before { subject.valid? }

  context "validating an object with no items" do
    subject { ThingWithItems.new(nil) }
    it { expect(subject.errors[:items]).to include("must be an array") }
  end

  context "validating an object with an empty array" do
    subject { ThingWithItems.new([])}
    it { expect(subject.errors[:items]).to include("must have at least 1 item") }
  end

  context "validating an object with an empty array" do
    subject { ThingWithItems.new([1,2,3,4,5,6])}
    it { expect(subject.errors[:items]).to include("must have at most 5 items") }
  end

  context "validation passes" do
    subject { ThingWithItems.new([1,2,3])}
    it { expect(subject.errors[:items]).to be_empty }
  end
end
