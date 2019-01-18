require 'sequel'

require_relative 'series.rb'

class RelatedSeries < Sequel::Model
    many_to_one :series
end
