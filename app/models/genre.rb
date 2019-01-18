require 'sequel'

require_relative 'series.rb'

class Genre < Sequel::Model
    many_to_many :series
end
