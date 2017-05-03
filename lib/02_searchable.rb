require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'

module Searchable
  def where(params)
    keys = params.keys.join(" = ? AND ")

    found_things = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{keys} = ?
    SQL

    found_things.map { |found_thing| self.new(found_thing) }
  end
end

class SQLObject
  extend Searchable
end
