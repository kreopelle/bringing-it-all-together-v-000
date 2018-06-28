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

end
