require 'sequel'

require_relative 'related_series.rb'

class Series < Sequel::Model
    one_to_many :related_series, class: :RelatedSeries
end
