class Volunteer
  attr_accessor :name, :id, :project_id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
    @project_id = attributes[:project_id]
  end

  def ==(volunteer_to_compare)
    if volunteer_to_compare != nil
      self.name() == volunteer_to_compare.name()
    else
      false
    end
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      name = volunteer.fetch("name")
      id = volunteer.fetch("id").to_i
      volunteers.push(Volunteer.new({name: name, id: id}))
    end
    volunteers
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def self.find(id)
    volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id};").first
    if volunteer
      name = volunteer.fetch("name")
      id = volunteer.fetch("id").to_i
      Volunteer.new({name: name, id: id})
    else
      nil
    end
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes[:name] != nil)
      @name = attributes[:name]
      DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
    elsif (attributes.has_key?(:project_name)) && (attributes[:project_name] != nil)
      project_name = attributes[:project_name]
      project = DB.exec("SELECT * FROM projects WHERE lower(name)='#{project_name.downcase}';").first
    end
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
  end

  def self.clear
    DB.exec("DELETE FROM volunteers *;")
  end

end