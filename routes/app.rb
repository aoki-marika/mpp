require 'sinatra/base'
require_relative 'base'

module Routes
    class AppController < BaseController
        get '/' do
            json({ 'hello': 'world' });
        end
    end
end
