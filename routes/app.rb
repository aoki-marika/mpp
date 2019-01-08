require 'sinatra/base'

require_relative 'base.rb'
require_relative '../models/config.rb'
require_relative '../utilities/filesystem.rb'

# config is required to load the db, and the db is required to require model files
CONFIG = Model::Config.new(Utilities::Filesystem.absolute_path(__FILE__, '../config.yml'));
DB = Sequel.sqlite(CONFIG.environments[ENV['RACK_ENV']].db);

require_relative '../models/user.rb'

module Routes
    class AppController < BaseController

        get '/' do
            json({ 'hello': 'world' });
        end
    end
end
