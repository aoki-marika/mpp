require 'sequel'

require_relative 'series.rb'
require_relative 'archive.rb'
require_relative 'serializer.rb'

class Path < Sequel::Model
    many_to_one :series
    one_to_many :archives
end

class PathSerializer < Serializer
    attribute :name

    has_one :series
    has_many :archives
end
