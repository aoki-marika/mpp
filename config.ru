require 'yaml'
require 'sequel'
require 'logger'

# a global logger for logging outside of sinatra requests
$logger = Logger.new STDOUT
$logger.formatter = proc do |severity, datetime, progname, msg|
    "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}  #{msg}\n"
end

def expand_dirname(path, base_file: __FILE__)
    File.expand_path(path, File.dirname(base_file))
end

# get the db path
db_config = YAML.load_file(expand_dirname('config/database.yml'))[ENV['RACK_ENV']]
db_path = "#{db_config['adapter']}://#{db_config['database']}"

# connect to the db
$db = Sequel.connect(db_path)

# make sure the database is up to date
Sequel.extension :migration
db_migrations = expand_dirname('db/migrations')

if !Sequel::Migrator.is_current?($db, db_migrations)
    $logger.info "Migrating database '#{db_path}'..."
    Sequel::Migrator.run($db, db_migrations)
end

# require controllers now that the db is connected
require_relative 'app/controllers/application.rb'

# map and run the application
map '/' do run ApplicationController end
