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

# get the db path
db_config = YAML.load_file(expand_dirname('config/database.yml'))[ENV['RACK_ENV']]
db_path = "#{db_config['adapter']}://#{expand_dirname(db_config['database'])}"
db_fresh = !File.exists?(db_path)

# connect to the db
$db = Sequel.connect(db_path)

# make sure the database is up to date
Sequel.extension :migration
db_migrations = expand_dirname('db/migrations')

if !Sequel::Migrator.is_current?($db, db_migrations)
    $logger.info "Migrating database '#{db_path}'..."
    Sequel::Migrator.run($db, db_migrations)

    # import the mangaindex database if it exists and the db is fresh
    #
    # to import from a madokami db dump, download a `mangaindex-data-*.mysql.xz` file from `/Info` on Madokami,
    # then use mysql2sqlite to convert it and move it to `db/mangaindex-data.sqlite`
    import_path = expand_dirname('db/madokami.sqlite')

    if db_fresh && File.exists?(import_path)
        $logger.info "Importing database 'sqlite://#{import_path}'..."

        Sequel.connect("sqlite://#{import_path}") do |import_db|
            import_series = import_db[:series].join(import_db[:path_records].select(:path, :series_id), series_id: :id)
                                              .select(:mu_id, :name, :path, :year, :description, :origin_status, :scan_status, :image, :created_at, :updated_at)

            $db[:series].multi_insert(import_series)
        end
    end
end

# require controllers now that the db is connected
require_relative 'app/controllers/application.rb'

# map and run the application
map '/' do run ApplicationController end
