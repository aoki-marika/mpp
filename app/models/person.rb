require 'sequel'

require_relative 'series.rb'

class Person < Sequel::Model
    many_to_many :series
end
