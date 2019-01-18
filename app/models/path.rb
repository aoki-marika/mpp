require 'sequel'

require_relative 'series.rb'
require_relative 'archive.rb'

class Path < Sequel::Model
    many_to_one :series
    one_to_many :archives
end
