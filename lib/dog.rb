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
    if 

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

end
