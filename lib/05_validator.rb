class Validator
  def initialize(column_names, options)
    @column_names = column_names
  end
end

module Validation
  def validates(*column_names, options)
  end

end

class SQLObject
  extend Validator
end
