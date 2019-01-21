require 'sequel'

require_relative 'series.rb'
require_relative 'serializer.rb'

class Person < Sequel::Model
    many_to_many :series
end

class PersonSerializer < Serializer
    attribute :name

    has_many :series
end
