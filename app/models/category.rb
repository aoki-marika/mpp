require 'sequel'

require_relative 'series.rb'

class Category < Sequel::Model
    many_to_many :series
end
