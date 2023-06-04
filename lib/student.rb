require_relative "../config/environment"

class Student
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end



    def self.create(name, grade)
      student = Student.new(name, grade)
      student.save
      student
    end

  def self.new_from_db(row)
    id,  name, grade = row
    Student.new(name, grade, id)
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    result = DB[:conn]. execute(sql, name)[0]
    if result
      self.new_from_db(result)
    else
      nil
    end
  end



  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
