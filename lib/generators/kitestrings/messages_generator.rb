module Kitestrings
  module Generators
    class MessagesGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def setup_messages_model
        template "message.rb.erb", "app/models/message.rb"
      end
    end
  end
end
