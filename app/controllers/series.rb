require_relative 'base.rb'
require_relative '../models/series.rb'

class SeriesController < BaseController
    get '/series/?' do
        page(Series)
    end
end
