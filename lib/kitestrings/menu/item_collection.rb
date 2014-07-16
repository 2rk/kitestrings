require 'delegate'

module Kitestrings
  class Menu::ItemCollection < ::SimpleDelegator
    attr :items

    def initialize(loaded_resources)
      length = loaded_resources.length
      @items = (0...length).map do |count|
        Menu::Item.new loaded_resources[0..count]
      end

      # if the last item in the resources is a new_record? object, then substitute it for the class. This will
      # cause polymorphic path to show the #index action in the breadcrumb instead of the new action, or a route
      # error looking for an object that has no id.
      last = @items.last
      if last && last.object.respond_to?(:new_record?) && last.object.new_record?
        @items.pop
        @items << Menu::Item.new(last.resources[0..-2] + [last.object.class])
      end

      # the last item in the array is assumed to be active.
      @items.last.active = true unless items.empty?

      # delegate all methods to this array object
      super(@items)
    end
  end
end
