CREATE TABLE gyms (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE trainers (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  gym_id INTEGER,

  FOREIGN KEY(gym_id) REFERENCES gym(id)
);

CREATE TABLE pokemons (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(255) NOT NULL,
  trainer_id INTEGER,

  FOREIGN KEY(trainer_id) REFERENCES trainers(id)
);

INSERT INTO
  gyms (id, name)
VALUES
  (1, "Cerulean"),
  (2, "Pewter");

INSERT INTO
  trainers (id, name, gym_id)
VALUES
  (1, "Brock", 2), (2, "Misty", 1), (3, "Ash", NULL);

INSERT INTO
  pokemons (id, name, type, trainer_id)
VALUES
  (1, "Onix", "Rock", 1),
  (2, "Pikachu", "Electric", 3),
  (3, "Starmy", "Water", 2),
  (4, "Charizard", "Fire", 3),
  (5, "Togepi", "Unknown", 2);
