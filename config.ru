require 'yaml'
require 'sequel'
require 'logger'

# a global logger for logging outside of sinatra requests
$logger = Logger.new STDOUT
$logger.formatter = proc do |severity, datetime, progname, msg|
    "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}  #{msg}\n"
end

# expand a relative path from the dirname of a given file
def expand_dirname(path, base_file: __FILE__)
    File.expand_path(path, File.dirname(base_file))
end

# connect to the db
db_path = expand_dirname("db/#{ENV['RACK_ENV']}.sqlite")
$db = Sequel.connect("sqlite://#{db_path}")

# load extensions
Sequel.extension :migration

$db.extension :pagination

Sequel::Model.plugin :tactical_eager_loading

# make sure the database is up to date
db_migrations = expand_dirname('db/migrations')

if !Sequel::Migrator.is_current?($db, db_migrations)
    $logger.info "Migrating database 'sqlite://#{db_path}'..."
    Sequel::Migrator.run($db, db_migrations)
end

# require controllers now that the db is connected
require_relative 'app/controllers/application.rb'

# map and run the application
map '/' do run ApplicationController end
