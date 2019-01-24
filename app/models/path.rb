require 'sequel'

require_relative 'series.rb'
require_relative 'archive.rb'
require_relative 'serializer.rb'

class Path < Sequel::Model
    many_to_one :series
    one_to_many :archives, key: :parent_id
end

class PathSerializer < Serializer
    attribute :path

    has_one :series
    has_many :archives
end
