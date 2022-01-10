require 'pry'

class Project
  attr_accessor :id, :title

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      title = project.fetch("title")
      id = project.fetch("id")
      projects.push(Project.new({title: title, id: id}))
    end
    projects
  end

  def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    title = project.fetch("title")
    id = project.fetch("id").to_i
    Project.new({title: title, id: id})
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(other_project)
    self.title.eql?(other_project.title)
  end

  def self.clear
    DB.exec("DELETE FROM projects *;")
  end

  def update(attributes)
    @title = attributes.fetch(:title)
    # @id = attributes.fetch(:id).to_i
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
  end

  def volunteers
    volunteers = []
    results = DB.exec("SELECT * FROM volunteers WHERE project_id = #{@id}")
    results.each do |result|
      volunteers.push(Volunteer.new({name: result.fetch("name"), project_id: result.fetch("project_id").to_i, id: result.fetch("id").to_i }))
    end 
    volunteers
  end

end