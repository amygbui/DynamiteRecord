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
