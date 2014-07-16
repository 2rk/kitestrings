module Kitestrings::Menu::Model
  extend ActiveSupport::Concern

  included do
    class_attribute :menu_name_method

    # default to :name
    self.menu_name_method = :name
  end

  # get the display name for this item in the menu structure. Defaults to the :name method, can be specified by setting
  # the menu_name_method class attribute on the class.
  def menu_display_name
    case
      when respond_to?(menu_name_method)
        self.send(menu_name_method)
      else
        "##{to_key}"
    end
  end

  module ClassMethods
    # Get the display name of the collection for this class (index action). This uses ActiveModel::Naming to fetch
    # the plural name of the resource class.
    def menu_display_name
      self.model_name.human.pluralize.titlecase
    end
  end
end
