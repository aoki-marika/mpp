require_relative 'model.rb'
require_relative 'path.rb'
require_relative 'related_series.rb'
require_relative 'genre.rb'
require_relative 'category.rb'
require_relative 'title.rb'
require_relative 'person.rb'

class Series < Model
    one_to_many :paths
    one_to_many :related_series, class: :RelatedSeries

    many_to_many :genres
    many_to_many :categories
    many_to_many :titles, join_table: :titles_series
    many_to_many :artists, join_table: :artists_series, right_key: :person_id, class: :Person
    many_to_many :authors, join_table: :authors_series, right_key: :person_id, class: :Person

    def api_data
        {
            :mu_id => @values[:mu_id],
            :title => @values[:name], #todo: rename series.name to title?
            :alternate_titles => titles,
            :year => @values[:year],
            :artists => artists,
            :authors => authors,
            :description => @values[:description],
            :origin_status => @values[:origin_status],
            :scan_status => @values[:scan_status],
            :image => @values[:image],
            :genres => genres,
            :categories => categories,
        }
    end
end
