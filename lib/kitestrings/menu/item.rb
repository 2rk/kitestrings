module Kitestrings::Menu
  # A class to represent an item in the menu. It is capable of looking up menu item paths and names and a link id,
  # all the required data to construct links, include links to subpaths
  class Item
    include Rails.application.routes.url_helpers

    attr :resources
    attr_accessor :active

    def initialize(resources)
      @resources = resources
    end

    # the path of the item. eg: /companies/1/projects/2/audits/3
    def path
      @path ||= polymorphic_path @resources
    end

    # return a new item with the given extra resources added to the resource list.
    def sub_item(*extras)
      Item.new([*@resources, *extras].compact)
    end

    def parent_item
      Item.new(resources[0..-2])
    end

    # return the menu display name for the object. This defaults to the .name method of an instance, and the
    # localised human name for classes.
    def name
      object.menu_display_name
    end

    # return the name of a menu partial to use for contextual menus relating to this item.
    def partial_name
      last = @resources.last
      klass = last.is_a?(Class) ? last : last.class
      klass.model_name.underscore
    end

    # fetch the last object in the chain. This is the resource that is actually being rendered. If this is an
    # index action, this will be the class representing the type to be shown in the list.
    def object
      @resources.last
    end

    # a string to use as a link id in the menu link. Eg: for the path /companies/1/projects/2, the link would be
    # menu_companies_projects_link
    def link_id
      names = @resources.map do |resource|
        case resource
          when Class
            resource.name.pluralize.downcase
          else
            resource.class.name.downcase
        end
      end
      "menu_#{names.join('_')}_link"
    end

    # Active is set on the last item in the Menu::ItemCollection based on the assumption that this is the active item
    # in the collection.
    def active?
      @active
    end

    # Should the item be hidden in the menus? If so, menu_link_to will not generate any output. Implement a menu_hidden
    # instance or class method to hide that instance or class from the menu.
    def hidden?
      if object.respond_to? :menu_hidden
        object.menu_hidden
      end
    end

    def collection?
      object.is_a?(Class)
    end

    # if this item is for a resource instance (eg: companies/1 => <# Company id:1 #>, then make a new item representing
    # the collection of that class, eg: companies/ => <# Company class #>
    def index_item
      if @resources.last && @resources.last.is_a?(ActiveRecord::Base)
        index_resources = @resources.dup
        index_resources << index_resources.pop.class
        Item.new index_resources
      end
    end

    # true if the object is persisted. Classes are not persisted.
    def persisted?
      object.respond_to?(:persisted?) && object.persisted?
    end
  end
end
