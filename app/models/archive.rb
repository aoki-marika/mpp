require 'sequel'

class Archive < Sequel::Model
    many_to_one :series_paths
end
