require 'active_support'

# a module for executing code asynchronously in another thread. This is disabled
module Async
  mattr_accessor :enabled

  # Execute the given block in another thread, but only in production. During development, the block executes
  # on the current thread
  # @return [Thread]
  def async
    raise "A block must be provided" unless block_given?
    if Async.enabled
      Thread.new do
        # ensure that this thread uses a new connection to the database and returns it to the pool when done.
          ActiveRecord::Base.connection_pool.with_connection do
          yield
        end
      end
    else
      yield
      Thread.current
    end
  end
end

Async.enabled = false
