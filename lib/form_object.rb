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
    end
  end

  # Validate the form object and if it's valid, call save on the underlying model object. If there are multiple models
  # that need to be saved you will need to reimplement this method.
  def save(*args)
    if valid?
      resource.save
    end
  end
end
