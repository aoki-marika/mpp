require_relative 'model.rb'
require_relative 'series.rb'

class Person < Model
    many_to_many :series

    def api_data
        {
            :name => @values[:name],
        }
    end
end
