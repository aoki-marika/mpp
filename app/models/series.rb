require 'sequel'

require_relative 'path.rb'
require_relative 'related_series.rb'
require_relative 'associated_title.rb'
require_relative 'genre.rb'
require_relative 'category.rb'
require_relative 'person.rb'
require_relative 'serializer.rb'

class Series < Sequel::Model
    one_to_many :paths
    one_to_many :related_series, class: :RelatedSeries

    many_to_many :associated_titles
    many_to_many :genres
    many_to_many :categories
    many_to_many :artists, join_table: :artists_series, right_key: :person_id, class: :Person
    many_to_many :authors, join_table: :authors_series, right_key: :person_id, class: :Person
end

class SeriesSerializer < Serializer
    attribute :title
    attribute :associated_titles do object.associated_titles.map { |t| t.name } end
    attribute :year
    attribute :description
    attribute :origin_status
    attribute :completely_scanlated
    attribute :image do "https://www.mangaupdates.com/image/#{object.image}" end

    has_many :paths
    has_many :genres
    has_many :categories
    has_many :artists
    has_many :authors
end
