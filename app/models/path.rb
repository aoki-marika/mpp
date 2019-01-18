require 'sequel'

class Path < Sequel::Model
    many_to_one :series
    one_to_many :archives
end
