require_relative 'lib/sql_object'
require_relative 'lib/db_connection'

class Gym < SQLObject
  has_many :trainers,
    class_name: "Trainer",
    primary_key: :id,
    foreign_key: :gym_id

  has_many_through :pokemons, :trainers, :pokemons

  finalize!
end

class Trainer < SQLObject
  has_many :pokemons,
    class_name: "Pokemon",
    primary_key: :id,
    foreign_key: :trainer_id

  belongs_to :gym,
    class_name: "Gym",
    primary_key: :id,
    foreign_key: :gym_id

  finalize!
end

class Pokemon < SQLObject
  belongs_to :trainer,
    class_name: "Trainer",
    primary_key: :id,
    foreign_key: :trainer_id

  has_one_through :gym, :trainer, :gym

  finalize!
end
