require 'rspec'
require 'pg'
require 'pry'

DB = PG.connect({ dbname: 'volunteer_tracker_test', host: 'db', user: 'postgres', password: 'password' })

RSpec.configure do |config|
  config.after(:each) do
    DB.exec('DELETE FROM volunteers *;')
    DB.exec('DELETE FROM projects *;')
  end
end
