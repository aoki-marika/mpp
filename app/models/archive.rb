require 'sequel'

require_relative 'path.rb'
require_relative 'serializer.rb'

class Archive < Sequel::Model
    many_to_one :paths
end

class ArchiveSerializer < Serializer
    attribute :name

    has_one :paths
end
