require 'sequel'

class RelatedSeries < Sequel::Model
    many_to_one :series
end
