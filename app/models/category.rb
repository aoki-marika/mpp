require 'sequel'

require_relative 'series.rb'
require_relative 'serializer.rb'

class Category < Sequel::Model
    many_to_many :series
end

class CategorySerializer < Serializer
    attribute :name

    has_many :series
end
