require 'sequel'

require_relative 'series.rb'

class Title < Sequel::Model
    many_to_many :series
end
