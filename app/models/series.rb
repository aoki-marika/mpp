require 'sequel'

require_relative 'path.rb'
require_relative 'related_series.rb'
require_relative 'genre.rb'
require_relative 'category.rb'
require_relative 'title.rb'
require_relative 'person.rb'

class Series < Sequel::Model
    one_to_many :paths
    one_to_many :related_series

    many_to_many :genres
    many_to_many :categories
    many_to_many :titles, join_table: :titles_series
    many_to_many :artists, join_table: :artists_series, right_key: :person_id, class: :Person
    many_to_many :authors, join_table: :authors_series, right_key: :person_id, class: :Person
end
