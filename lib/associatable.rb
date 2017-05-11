require_relative 'assoc_options'
require 'active_support/inflector'

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

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options
                       .model_class.assoc_options[source_name]

      # Cat belongs to human, so it has the foreign key
      through_table = through_options.table_name # humans
      through_primary_key = through_options.primary_key # human.id
      through_foreign_key = through_options.foreign_key # cat.owner_id

      # Human belongs to a house, so it has foreign_key
      source_table = source_options.table_name # houses
      source_primary_key = source_options.primary_key # house.id
      source_foreign_key = source_options.foreign_key # human.house_id

      owner_key_val = self.send(through_foreign_key)

      # SELECT houses.*
      # FROM humans
      # JOIN houses
      # ON houses.id = humans.house_id
      # WHERE humans.id = cats.owner_id

      results = DBConnection.execute(<<-SQL, owner_key_val)
        SELECT
          #{source_table}.*
            -- select * returns data from both humans and houses
            -- need to select out only House data, otherwise parse method breaks
            -- this is because a House can't parse for columns/keys it doesn't have
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{source_table}.#{source_primary_key} = #{through_table}.#{source_foreign_key}
            -- house.id = human.house_id
            -- house can have many humans so need to filter out the one human
        WHERE
          #{through_table}.#{through_primary_key} = ?
            -- human.id = cat.owner_id
            -- cat can only belong to one human, so we filter out human owner
      SQL

      source_options.model_class.parse_all(results).first
    end
  end

  def has_many_through(name, through_name, source_name)
    # House has_many :cats, through: :humans, source: :cats
    through_assoc = "humans".to_sym if through_name == "human"
    through_assoc ||= through_name.to_s.tableize.to_sym
    source_assoc = source_name.to_s.tableize.to_sym

    define_method(name) do
      through_options = self.class.assoc_options[through_assoc]
      source_options = through_options
                       .model_class.assoc_options[source_assoc]

      through_table = through_options.table_name # humans
      through_primary_key = through_options.primary_key # human.id
      through_foreign_key = through_options.foreign_key # cat.owner_id

      # Human belongs to a house, so it has foreign_key
      source_table = source_options.table_name # cats
      source_primary_key = source_options.primary_key # human.id
      source_foreign_key = source_options.foreign_key # cats.house_id

      owner_key_val = self.send(through_primary_key)

      # SELECT *
      # FROM humans
      # JOIN cats
      # ON humans.id = cats.owner_id
      # WHERE houses.id = humans.house_id

      results = DBConnection.execute(<<-SQL, owner_key_val)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_primary_key} = #{source_table}.#{source_foreign_key}
            -- human.id = cats.owner_id
        WHERE
          #{through_table}.#{through_foreign_key} = ?
            -- human.house_id = house.id
      SQL

      source_options.model_class.parse_all(results)
    end
  end
end
