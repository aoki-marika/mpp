require 'sequel'

require_relative 'staff.rb'
require_relative 'path.rb'
require_relative 'series_relationship.rb'
require_relative 'associated_title.rb'
require_relative 'genre.rb'
require_relative 'category.rb'
require_relative 'serializer.rb'

class Series < Sequel::Model
    one_to_many :staff
    one_to_many :paths
    one_to_many :series_relationships, key: :source_id

    many_to_many :associated_titles
    many_to_many :genres
    many_to_many :categories
end

class SeriesSerializer < Serializer
    attribute :title
    attribute :associated_titles do object.associated_titles.map { |t| t.name } end
    attribute :year
    attribute :description
    attribute :origin_status
    attribute :completely_scanlated
    attribute :image do "https://www.mangaupdates.com/image/#{object.image}" end

    has_many :genres
    has_many :categories
    has_many :staff
    has_many :series_relationships
    has_many :paths
end
