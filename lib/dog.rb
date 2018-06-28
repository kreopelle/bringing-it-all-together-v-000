class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(attr_hash)
    @id = attr_hash[:id]
    @name = attr_hash[:name]
    @breed = attr_hash[:breed]
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end

  def save
      sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
  end

  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  def self.create(attr_hash)
    dog = Dog.new(attr_hash)
    dog.save
    dog
  end

  def self.new_from_db(row)
    dog = Dog.new(row[0], row[1], row[2])
    dog.save
    dog
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ?"
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    dog = DB[:conn].execute(sql, id)
    dog_data = dog[0]
    dog_hash = {id: dog_data[0], name: dog_data[1], breed: dog_data[2]}
    dog = Dog.new(dog_hash)
    dog
  end

  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?")
    if !dog.empty?
      dog_data = dog[0]
      dog_hash = {id: dog_data[0], name: dog_data[1], breed: dog_data[2]}
      dog = Dog.new(dog_hash)
      dog
    else
      self.create(name:, breed:)

end
