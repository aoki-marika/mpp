require 'sequel'

require_relative 'path.rb'

class Archive < Sequel::Model
    many_to_one :paths
end
