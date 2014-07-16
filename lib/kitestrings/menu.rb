module Kitestrings::Menu
  extend ActiveSupport::Concern

  # include Kitestrings::Menu into ApplicationController or each controller where required.
  included do
    include Controller
    helper ViewHelper
    helper_method :current_menu_item
  end
end
