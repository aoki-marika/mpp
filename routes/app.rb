require 'yaml'
require 'sequel'
require 'sinatra/base'

require_relative '../utilities/filesystem.rb'

# get the db path
db_config_path = Utilities::Filesystem.absolute_path(__FILE__, '../config/database.yml'); # the path for the db config file
db_config = YAML.load_file(db_config_path)[ENV['RACK_ENV']]; # the db config for the current environment

# connect to the db
DB = Sequel.connect("#{db_config['adapter']}://#{db_config['database']}");

# require models and files using them now that the db is connected
require_relative '../models/user.rb'
require_relative 'base.rb'

module Routes
    class AppController < BaseController

        get '/' do
            json({ 'hello': 'world' });
        end
    end
end
