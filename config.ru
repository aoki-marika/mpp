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
            # get the series metadata
            import_series = import_db[:series].distinct
                                              .select(:id, :mu_id, :name, :path, :year, :description, :origin_status, :scan_status, :image, :created_at, :updated_at)
                                              .join(import_db[:path_records].select(:path, :series_id), series_id: :id)
                                              .group(:id)

            # todo: probably trim "From __:" and "Note:" from series descriptions, potentially move note into its own column
            # todo: filter out unwanted directories, e.g. `/Manga/Non-English`

            # get the related series metadata
            require_relative 'app/models/related_type.rb'
            import_related = import_db[:related_series].select(:id, :series_id, :related_mu_id, :type).all.each do |r|
                case r[:type]
                    when 'Main Story'
                        type = RelatedType::MAIN_STORY
                    when 'Adapted From'
                        type = RelatedType::ADAPTED_FROM
                    when 'Alternate Story'
                        type = RelatedType::ALTERNATE_STORY
                    when 'Spin-Off'
                        type = RelatedType::SPIN_OFF
                    when 'Side Story'
                        type = RelatedType::SIDE_STORY
                    when 'Prequel'
                        type = RelatedType::PREQUEL
                    when 'Sequel'
                        type = RelatedType::SEQUEL
                end

                r[:type] = type
            end

            # import series
            $logger.info "Importing series..."
            $db[:series].multi_insert(import_series)

            # import related series
            $logger.info "Importing related series..."

            # disable foreign key checks so all the related series can be imported then verified
            $db.run 'PRAGMA foreign_keys = OFF'
            $db[:related_series].multi_insert(import_related)
            $db[:related_series].exclude(series_id: $db[:series].select(:id)).delete
            $db.run 'PRAGMA foreign_keys = ON'
        end
    end
end

# require controllers now that the db is connected
require_relative 'app/controllers/application.rb'

# map and run the application
map '/' do run ApplicationController end
