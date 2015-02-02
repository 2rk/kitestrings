require 'rails_helper'
require 'async'

module ActiveRecord
  class Base
  end
end

describe Async do
  class Example
    include Async

    attr :result

    def calculate
      async do
        @result = Thread.current
      end
    end
  end

  before do
    # stub active record for tests so we don't need a database connection.
    pool = double("connection pool")
    pool.stub(:with_connection).and_yield
    ActiveRecord::Base.stub(:connection_pool => pool)
  end

  subject { Example.new }

  it "done on same thread in tests" do
    Thread.should_not_receive :new
    subject.calculate
    expect(subject.result).to eq(Thread.current)
  end

  it "done on a different thread" do
    Async.stub :enabled => true
    thread = subject.calculate
    expect(thread).to be_a(Thread)
    expect(thread).not_to eq(Thread.current)
    thread.join
    expect(subject.result).to eq(thread)
  end

  it "raises an exception if no block is given" do
    expect { subject.async }.to raise_error(RuntimeError)
  end
end
