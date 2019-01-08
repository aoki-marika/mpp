require 'yaml'
require 'ostruct'

require_relative '../utilities/filesystem.rb'

module Model
    class Config
        attr_accessor :environments

        def initialize(path)
            config = YAML.load_file(path);

            # load all the environment configs from the yaml file
            @environments = config.map { |e|
                # the k/v pairs from this environment config
                values = e[1];

                # make sure there is a db key
                raise ArgumentError, 'Environment configurations need a \'db\' key.' unless values.key?('db');

                # store the options in an ostruct
                options = OpenStruct.new;
                options.db = Utilities::Filesystem.absolute_path(path, values['db']);

                # return a k/v pair of environment name nad options
                [e[0], options];
            }.to_h # convert to a hash so environments can be accessed by string name
        end
    end
end
