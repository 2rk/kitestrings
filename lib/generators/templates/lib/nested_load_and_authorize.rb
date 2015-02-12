module NestedLoadAndAuthorize
  # load and authorise the resource with the same parameters as the Can Can controller additions
  # class macro load_and_authorize_resource.
  #
  # This differs in that it is an instance method, so you must call it in a before_filter (or
  # from another instance method).
  #
  # This method has no effect if the resource is already loaded.
  #
  # Any block passed to this method will be executed if the resource was successfully loaded by
  # this call. Nested calls automatically supply the +:through+ parameter. To bypass this, set
  # :through => nil.
  # rubocop:disable
  def load_and_authorize(name, options = {})
    @_through_stack ||= []

    # only touch can can if the instance variable is nil
    resource = instance_variable_get("@#{name}")
    if resource.nil?
      # apply if, only and except behaviours just is if this was done by before_filter
      proceed = true
      proceed &&= [*options[:only]].include?(action_name.to_sym) if options[:only]
      proceed &&= ![*options[:except]].include?(action_name.to_sym) if options[:except]
      proceed &&= case options[:if]
                    when Symbol
                      send(options[:if])
                    when Proc
                      options[:if].call
                    when nil
                      true
                  end

      if proceed
        # automatically load this resource through a nested one unless manually specified
        options[:through] = @_through_stack.last unless @_through_stack.empty? || options.include?(:through)
        # create the can can resource class
        cancan = self.class.cancan_resource_class.new(self, name, options.except(:if, :only, :except, :param))
        resource = cancan.load_resource
        cancan.authorize_resource unless options[:skip_authorize]
        if resource && block_given?
          # only call block if we got an instance variable set
          begin
            @_through_stack.push(name)
            yield
          ensure
            @_through_stack.pop
          end
        end
      end
    end
    resource
  end

  # syntactic sugar for adding the :skip_authorize option
  def load_resource(name, options = {}, &block)
    options[:skip_authorize] = true
    load_and_authorize(name, options, &block)
  end

  # load the resource only if its request parameter is present. This allows for optional nesting to
  # work like shallow routes with the before_filter way of doing things.
  def load_and_authorize_if_present(name, options = {}, &block)
    key = options[:id_param] || "#{name}_id"
    if params[key]
      load_and_authorize(name, options, &block)
    end
  end
end
