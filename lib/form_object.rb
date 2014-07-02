# This module is to help with using Form Objects that are backed by ActiveRecord resources. The goal
# is to make a from object act like the underlying model class, but with its own set of validations.
#
# Note that saving the form object requires validations in the form object to pass *AND* the validations
# in the underlying model object. Validation errors in the underlying model object will be included in
# the errors of the form object.
module FormObject
  extend ActiveSupport::Concern
  include ActiveModel::Model

  module ClassMethods
    # Set up the Form Object class to be a form object for a given model.
    #
    # Example:
    #
    # class NewWorkflow
    #   include FormObject
    #   form_object_for :workflow, :fields => [:name], :class => MyOtherClass
    #   ...
    #
    # This creates a :workflow attr method and delegates methods to it for use with form_for.
    def form_object_for(resource_name, options={})
      # create an attribute for the underlying resource name, (eg :workflow) and make an alias method "resource"
      # for the attr reader
      attr resource_name
      alias_method :resource, resource_name

      # create a class attribute with the model name of the underlying model name so that polymorphic_url will
      # see the form object as if it were an instance of the underlying model object.
      class_attribute :model_name
      klass = options[:class] || resource_name.to_s
      klass = klass.camelize.constantize unless klass.is_a?(Class)
      self.model_name = klass.model_name

      # delegate the following methods to the underlying model object, also helps polymorphic_url do the right thing
      # for `form_for @form_object`
      methods_to_delegate = [:id, :persisted?, :to_param]
      if options[:fields]
        options[:fields].each do |field|
          methods_to_delegate << "#{field}".to_sym
          methods_to_delegate << "#{field}=".to_sym
        end
      end
      delegate *methods_to_delegate, :to => resource_name
      include DelegateEverything if options[:delegate_everything]

      # create a default initializer which will set the resource when a single parameter is passed in.
      define_method :initialize do |object=nil|
        instance_variable_set("@#{resource_name}", object)
      end
    end
  end

  # Validate the form object and if it's valid, call save on the underlying model object. If there are multiple models
  # that need to be saved you will need to reimplement this method.
  def save(*args)
    if valid?
      resource.save
    end
  end

  # The form object is valid when its validations pass *AND* the underlying model validations pass. If there
  # are errors in the underlying resource, those errors are copied into the errors object for this form object
  # so that they exist in a single place (easy for the form to work with)
  def valid?
    result = [super, resource.valid?].all?

    # include any errors in the resource object in the +errors+ for this form object. This is useful
    # for uniqueness validation or existing validations in the model class so that they don't need
    # to be duplicated in the form object. (And especially uniqueness validators can only be run in
    # the ActiveRecord::Base model class.
    unless result
      resource.errors.each do |attr, error|
        errors[attr] << error unless errors[attr].include?(error)
      end
    end

    result
  end

  # implement update as per ActiveRecord::Persistence
  def update(attrs)
    assign_attibutes(attrs)
    save
  end

  alias update_attributes update

  module DelegateEverything
    def method_missing(method, *args, &block)
      if resource.respond_to?(method)
        resource.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_all)
      resource.respond_to?(method, include_all) || super
    end
  end
end
