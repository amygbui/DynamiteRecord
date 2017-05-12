# DynamiteRecord

DynamiteRecord is a custom object relational database library that creates and maps Ruby objects to tables in the database. DynamiteRecord abstracts away complicated SQL queries and provides a simple and intuitive interface for users to effectively interact with the database.

## Demo
To see this library in action, follow these steps:
1. Clone this repository
2. Load `irb` or `pry` in the terminal
3. Run `load 'demo.rb'`
4. Test it out!

For your reference, here are the tables in the demo database:

### Gyms
Column          | Data Type | Details
--------------- | --------- | -------
id              | integer   | not null, primary key
name            | string    | not null

### Trainers
Column          | Data Type | Details
--------------- | --------- | -------
id              | integer   | not null, primary key
name            | string    | not null
gym_id          | integer   |

### Pokemon
Column          | Data Type | Details
--------------- | --------- | -------
id              | integer   | not null, primary key
name            | string    | not null
type            | string    | not null
trainer_id      | integer   | not null

## Use in Private Projects
Want to use this library for your own database? Follow these steps:
1. Download the contents of the lib folder
2. Change `demo.sql` file to your own SQLite3 table file in `db_connection.rb`
3. Replace `demo.db` with what you want your database file name to be in `db_connection.rb`
4. Start making models!

## Libraries
* SQLite3 (gem)
* ActiveSupport::Inflector

## List of Features
* Defines getter and setter methods for all columns in a table, allowing easy access to data
* Has custom "tableize" method to turn model names into table names

## DynamiteRecord Methods
* `all` - returns a DynamiteRecord object for each and every row within the object's table in the database
* `first` - returns first/oldest row inserted into a table
* `last` - returns row most recently inserted into a table
* `find(id)` - allows easy querying of rows via an `id` key; returns a DynamiteRecord object with the given id
* `where(params)` - takes a hash as an argument and returns an array of DynamiteRecord objects that match the key/value pairs given.
* `insert` - inserts a new row into the database with the DynamiteRecord object's attributes
* `update` - updates the database with the DynamiteRecord object's current attributes
* `save` - inserts or updates the database with the DynamiteRecord object's current attributes
* `belongs_to(name, options)` - creates an association between two tables, where the current model class holds the foreign key referencing the other table
* `has_many(name, options)` - creates an association between two tables, where the other model class holds the foreign key pointing to the current model's table
* `has_one_through(name, through_name, source_name)` - creates an association between two tables (current model class table and source table), with an intermediary table (through) joining the two tables (traverses through two belongs_to assocations)
* `has_many_through(name, through_name, source_name)` - creates an association between two tables (current model class table and source table), with an intermediary table (through) joining the two tables (traverses through two has_many associations)
