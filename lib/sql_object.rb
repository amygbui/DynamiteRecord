require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'

require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT DISTINCT
        *
      FROM
        #{self.table_name}
      SQL
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end

      define_method("#{column}=") do |arg|
        attributes[column] = arg
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL

    self.parse_all(results)
  end

  def self.first
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        1
      SQL

    self.parse_all(results)[0]
  end

  def self.last
    self.all[-1]
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    attribute_data = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL

    attribute_data.empty? ? nil : self.new(attribute_data.first)
  end

  def initialize(params = {})
    keys = params.keys.map(&:to_sym).each do |key|
      raise "unknown attribute '#{key}'" unless self.class.columns.include?(key)
    end

    params.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def insert
    cols = self.class.columns - [:id]
    col_names = cols.join(", ")
    n = cols.length
    question_marks = Array.new(n, "?").join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    columns = self.class.columns - [:id]
    col_names = columns.join(" = ?, ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1), self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names} = ?
      WHERE
        id = ?
    SQL
  end

  def save
    self.class.find(self.id) ? update : insert
  end
end
