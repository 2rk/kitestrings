# A validator to validate the length of an array. Works on a collection proxy (has_many relationship) too.
class ArrayValidator < ActiveModel::EachValidator
  # Validate the value is an Array and optionally that the number of items in it is at least a minimum or at most a
  # maximum.
  #
  # Example:
  #  validates :address_states, array: {min: 1, min_message: "must have at least 1 State selected"},
  #
  def validate_each(record, attribute, value)
    if value.is_a? Array
      if options[:min].present? && value.size < options[:min]
        record.errors.add attribute, options[:min_message] || "must have at least #{options[:min]} #{'item'.pluralize(options[:min])}"
      end

      if options[:max].present? && value.size > options[:max]
        record.errors.add attribute, options[:max_message] || "must have at most #{options[:max]} #{'item'.pluralize(options[:max])}"
      end
    else
      record.errors.add attribute, "must be an array"
    end
  end
end
