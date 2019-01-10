require 'yaml'
require 'sequel'

def expand_dirname(path, base_file: __FILE__)
    File.expand_path(path, File.dirname(base_file))
end

DB_CONFIG = expand_dirname('config/database.yml')
DB_MIGRATIONS = expand_dirname('db/migrations')

# get the db path
db_config = YAML.load_file(DB_CONFIG)[ENV['RACK_ENV']]
db_path = "#{db_config['adapter']}://#{db_config['database']}"

# connect to the db
DB = Sequel.connect(db_path)

# make sure the database is up to date
Sequel.extension :migration

if !Sequel::Migrator.is_current?(DB, DB_MIGRATIONS)
    puts "Migrating database '#{db_path}'..."
    Sequel::Migrator.run(DB, DB_MIGRATIONS)
end

# require controllers now that the db is connected
require_relative 'app/controllers/application.rb'

# map and run the application
map '/' do run ApplicationController end
