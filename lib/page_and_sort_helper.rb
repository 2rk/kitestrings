module PageAndSortHelper

  # read the sort column from the params hash, returning it as a symbol, or nil
  # @return [Symbol]
  def sort_column
    params[:sort].try(:to_sym) || @_sort_order
  end

  # return the sort direction, defaulting to ascending, as a symbol. :asc or :desc
  # @return [Symbol]
  def sort_direction(default=nil)
    direction = (params[:sort_direction] || @_sort_direction || default || :asc).to_sym
    [:asc, :desc].include?(direction) ? direction : :asc
  end

  # create a link for the field by localising the field name and appending an up or down arrow indicating the current
  # sort order if this field is the currently sorted field. The sort order in the link is opposite to the current
  # sort order so that the user can toggle the sort order by clicking the link again.
  #
  # This defaults to looking up the field name on the class used in the controller for +page_and_sort+.
  def sortable_title(field, options={})
    klass = options[:class]
    title = h(options[:title] || (klass || @_sort_klass).human_attribute_name(field))

    direction = :asc
    if sort_column == field
      if sort_direction == :asc
        title += " &#x2193;".html_safe
        direction = :desc
      else
        title += " &#x2191;".html_safe
      end
    end

    link_to title, params.merge(sort: field, sort_direction: direction)
  end

  module Controller

    # return the given scope paged and sorted according to the query modifiers present in params. This includes:
    # 1. Using kaminari for paging long lists.
    # 2. Sorting the results by params[:sort] in the params[:sort_direction] direction (default to ASC)
    #
    # Note, complex order bys can be delegated to a class method (or scope) which will be passed the
    # direction ("asc" or "desc"). The class method / scope should be named "order_by_" followed by the name of the
    # sort.
    #
    # For example:
    # class Model < ActiveRecord::Base
    #   scope :order_by_complex_thing, lamda { |direction| order("complex order clause here") }
    # end
    #
    # And use this by params[:sort] = "complex_thing"
    def page_and_sort(scope, options={})

      # get the ActiveRecord class for the scope.
      klass =
          case
            when Array
              scope
            when scope.respond_to?(:scoped)
              scope.scoped.klass
            when ActiveRecord::Base
              scope.all
            else
              scope
          end

      # save the sorting object class, so that it can be used as the localisation scope to look up the attribute
      # name for the link
      @_sort_klass = klass

      # apply the order scope if present, prefering a class method / scope if defined, otherwise composing the clause
      # using arel attributes so the sort order is safe to use with queries with joins, etc.
      field = sort_column || options[:default_sort]
      if field
        # save the sort order in the controller's instance variables where it can be accessed by the view helper
        # above to show the current sort order even if it is not specified by params[:sort]
        @_sort_order = field
        @_sort_direction = sort_direction(options[:default_direction])

        scope =
            if klass.respond_to? "order_by_#{field}"
              scope.__send__ "order_by_#{field}", @_sort_direction
            else
              attribute = klass.arel_table[field]
              scope.order(@_sort_direction == :asc ? attribute.asc : attribute.desc)
            end
      end

      # apply kaminari pagination
      if scope.respond_to?(:page) && !options[:skip_pagination]
        scope.page(params[:page])
      else
        scope
      end
    end
  end
end
