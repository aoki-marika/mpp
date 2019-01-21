require 'sequel'

require_relative 'series.rb'
require_relative 'serializer.rb'

class Genre < Sequel::Model
    many_to_many :series
end

class GenreSerializer < Serializer
    attribute :name

    has_many :series
end
