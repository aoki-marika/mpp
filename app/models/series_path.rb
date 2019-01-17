require 'sequel'

class SeriesPath < Sequel::Model
    many_to_one :series
end
