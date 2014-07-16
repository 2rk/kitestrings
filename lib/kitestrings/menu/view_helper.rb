module Kitestrings
  module Menu::ViewHelper

    # Generate a <li><a href="path">name</li> html string.
    #
    # This is done from a Menu::Item object that fetches the path and display name from a resource(model, or any
    # object with Menu::Model included in it.).
    #
    # Examples:
    #    menu_link_to(current_menu_item)
    #    menu_link_to(current_menu_item.sub_item(OtherModel)) # link to nested index page of OtherModel under current path
    #    menu_link_to(:name => "Explicit", :path => path_method()) # specify name and path explicitly
    #    menu_link_to("Explicit", :path => path_method()) # specify name and path explicitly
    #    menu_link_to(@resource) # will link to resource_path(@resource)
    #    menu_link_to([@user, @mail]) # will link to user_mail_path(@user, @mail)
    #    menu_link_to([@user, Message]) # will link to user_messages_path(@user)
    #
    def menu_link_to(item, options={})
      case
        when item.is_a?(Hash)
          # for use like:   menu_item(name: "Selections", path: selections_path())
          options = item
          item = Menu::Item.new([])
        when item.is_a?(Array)
          item = Menu::Item.new(item)
        when item.is_a?(String)
          options[:name] = item
          item = Menu::Item.new([])
        when !item.is_a?(Menu::Item)
          item = Menu::Item.new([item])
      end

      # use explicitly given path, or calculate using polymorphic_path:
      path = options.delete(:path) ||
          begin
            if item.object.respond_to?(:new_record?) && item.object.new_record?
              polymorphic_path item.resources[0..-2] + [item.object.class]
            else
              item.path
            end
          rescue NoMethodError, ActionController::RoutingError
            Rails.logger.error("Menu item has no path: #{item.inspect}")
            nil
          end

      if path && !item.hidden?
        active = path == request.path # need to check request action perhaps? eg: GET, PUT, POST, etc.

        name = options.delete(:name) || item.name || ''

        # truncate long plain  strings with an elipsis
        if name.length > 30 && !name.html_safe?
          name = name[0..30] + "…"
        end
        options[:id] ||= item.link_id
        options[:class] ||= ''
        options[:class] += ' active' if active

        # only generate the <li> tag if we have a name to display and a path to go to.
        if name.present?
          content_tag(:li, link_to(name, path, options))
        end
      end
    end
  end
end
