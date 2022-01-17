require 'sinatra'
require 'sinatra/reloader'
also_reload 'lib/**/*.rb'
require 'pry'
require "pg"
require './lib/project'
require './lib/volunteer'

DB = PG.connect({ dbname: 'volunteer_tracker', host: 'db', user: 'postgres', password: 'password' })

get '/' do
  @projects = Project.all
  erb(:projects)
end

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

delete('/projects') do
  Project.clear
  Volunteer.clear
  redirect to('/projects')
end

get('/projects/new') do
  erb(:new_project)
end

post('/projects') do
  @project = Project.new(title: params[:title])
  @project.save()
  @projects = Project.all
  erb(:projects)
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i())
  erb(:edit_project)
end

patch('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  @project.update({title: params[:title]})
  @projects = Project.all
  erb(:projects)
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.delete()
  @projects = Project.all
  erb(:projects)
end

post('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i())
  @volunteer = Volunteer.new({name: params[:name], project_id: @project.id})
  @volunteer.save()
  erb(:project)
end

get('/projects/:id/volunteers/:volunteer_id') do
  @project = Project.find(params[:id].to_i())
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  erb(:volunteer)
end
 
patch('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  @project = Project.find(params[:id].to_i)
  @volunteer.update({name: params[:name], id: params[:id].to_i, volunteer_id: params[:volunteer_id].to_i})
  @volunteers = Volunteer.all
  erb(:project)
end

delete('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  @project = Project.find(params[:id].to_i)
  @volunteer.delete()
  @volunteers = Volunteer.all
  erb(:project)
end