module Kitestrings
  module Generators
    class MessagesGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path("../message_templates", __FILE__)

      def setup_messages_model
        template "message.rb.erb", "app/models/message.rb"
        copy_file "message_mailer.rb", "app/mailers/message_mailer.rb"
        copy_file "default.text.erb", "app/views/message_mailer/default.text.erb"
        copy_file "message_spec.rb", "spec/models/message_spec.rb"
        copy_file "messages.rb", "spec/factories/messages.rb"
        copy_file "messages_controller.rb", "app/controllers/messages_controller.rb"
        copy_file "messages_controller_spec.rb", "spec/controllers/messages_controller_spec.rb"
        copy_file "index.html.haml", "app/views/messages/index.html.haml"
        copy_file "show.html.haml", "app/views/messages/show.html.haml"

        if Dir.glob(destination_root + "/db/migrate/*create_messages.rb").count == 0
          migration_template "message_migration.rb", "db/migrate/create_messages.rb"
        end

        routes = <<RUBY
  resources :messages, only: [:index, :show]
  # also nest under user, for example:
  # resources :user do
  #   resources :messages, only: [:index, :show]
  # end
RUBY
        inject_into_file "config/routes.rb", routes, :before => /^end/


        puts <<OUTPUT
-------------------------------------------------------------------------------

Kitestrings Message scaffold. Please complete the following manually:

1. Check config/routes.rb for nesting messages under the user model. For example:

  resources :user do
    resources :messages, only: [:index, :show]
  end

2. Update CanCan abilities so users can read their messages, for example:

    can(:read, Message) { |message| message.user == user }
    can(:index_all, Message) if user.admin?

3. Add the following to your user model

  has_many :messages

4. Set the default host. This is needed as the Message model needs to generate
   absolute URLs to be inserted into email bodies. Example, add to routes.rb:

  default_url_options :host => (ENV['DEFAULT_URL_HOST'] || 'localhost')

5. Add "message" and "message_other" to your common lets. Example:

  # Messages
  let(:message) { create :message, user: user }
  let(:message_other) { create :message, user: user_other }

-------------------------------------------------------------------------------
OUTPUT
      end

      def self.next_migration_number(dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
