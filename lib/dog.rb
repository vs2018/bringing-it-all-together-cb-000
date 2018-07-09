class Dog
  
  attr_accessor :name, :breed
  attr_reader :id
  
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL
          CREATE TABLE IF NOT EXISTS dogs(
          id INTEGER PRIMARY KEY,
          name TEXT,
          breed TEXT
          );
          SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end
  
  def save
    
    sql = <<-SQL
          INSERT INTO dogs(name, breed) 
          VALUES (?, ?);
          SQL
          
    DB[:conn].execute(sql, self.name, self.breed)
    
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end
  
  def self.create(dog_name:, dog_breed:)
    
    instance = self.new(name: dog_name, breed: dog_breed)
    instance.save
    
  end
  
  def self.new_from_db(row)
  new_student = self.new(row[1], row[2], row[0])
  new_student  
  end
end