require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    default = {
      class_name: name.to_s.capitalize,
      primary_key: :id,
      foreign_key: "#{name}_id".to_sym
    }

    options = default.merge(options)

    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    default = {
      class_name: name.to_s.singularize.capitalize,
      primary_key: :id,
      foreign_key: "#{self_class_name.to_s.downcase}_id".to_sym
    }

    options = default.merge(options)

    @class_name = options[:class_name]
    @primary_key = options[:primary_key]
    @foreign_key = options[:foreign_key]
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      object = options.model_class
      foreign_key = self.send(options.foreign_key)
      object.where(options.primary_key => foreign_key).first
    end

    assoc_options[name] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)

    define_method(name) do
      object = options.model_class
      foreign_key = self.send(options.primary_key)
      all = object.where(options.foreign_key => foreign_key)
    end

    assoc_options[name] = options
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
