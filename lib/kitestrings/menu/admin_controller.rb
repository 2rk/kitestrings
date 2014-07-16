module Kitestrings
  module Menu::AdminController
    def menu_context
      Admin.new
    end

    # this class acts like a Menu::Item
    class Admin

      # pretend to be a persisted resource (new pages don't show context menu)
      def persisted?
        true
      end

      # use 'admin' as the menu partial name
      def partial_name
        "admin"
      end
    end
  end
end
