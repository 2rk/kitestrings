module Kitestrings
  module Menu::Controller
    # return an array of the menu items constructed as polymorphic paths. For example, if loaded_resources was:
    # [Company:1, Project:2, Audit:3] then this would return an array of Menu::Item objects for the following paths:
    #   - /companies/1
    #   - /companies/1/projects/2
    #   - /companies/1/projects/2/audits/3
    #
    # Each item is constructed with polymorphic path
    def loaded_menu_items
      @loaded_menu_items ||= Menu::ItemCollection.new(loaded_resources)
    end

    # get the menu item for the contextual menu (second row). On an index page, this is the item the index is nested
    # under, if present. For normal pages it is the last item in the array.
    def current_menu_item
      if action_name == "index"
        loaded_menu_items[-2]
      else
        loaded_menu_items[-1]
      end
    end
  end
end
