# DynamiteRecord

DynamiteRecord is a custom object relational database library that creates and maps Ruby objects to tables in the database. DynamiteRecord abstracts away complicated SQL queries and provides a simple and intuitive interface for users to effectively interact with the database.

## Demo
To see this library in action, follow these steps:
1. Clone this repository
2. Load `irb` or `pry` in the terminal
3. Run `load 'demo.rb'`
4. Test it out!

## Libraries
* SQLite3 (gem)
* ActiveSupport::Inflector

## List of Features
* Defines getter and setter methods for all columns in a table, allowing easy access to data

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
 <!-- - creates a BelongsToOptions instance to create an association between two database tables; then, it creates an association with 'name' to access the associated object -->
* `has_many(name, options)` - creates an association between two tables, where the other model class holds the foreign key pointing to the current model's table
<!-- - creates an HasManyOptions instance to create an association between two database tables; then, it creates an association with 'name' to access the associated objects -->
* `has_one_through(name, through_name, source_name)` - creates an association between two tables (current model class table and source table), with an intermediary table (through) joining the two tables (traverses through two belongs_to assocations)
 <!-- - creates an association between two objects through an existing assocation. Goes through two ::belongs_to methods in order to access the associated object. Then, defines a method as an association with 'name' to access the associated object. -->
* `has_many_through(name, through_name, source_name)` - creates an association between two tables (current model class table and source table), with an intermediary table (through) joining the two tables (traverses through two has_many associations)
