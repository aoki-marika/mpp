require_relative 'model'
require_relative 'series.rb'

class Title < Model
    many_to_many :series

    def api_data
        @values[:name]
    end
end
