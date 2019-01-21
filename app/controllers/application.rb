require_relative 'base.rb'
require_relative 'series.rb'

class ApplicationController < BaseController
    use SeriesController
end
