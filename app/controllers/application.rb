require_relative 'base.rb'

class ApplicationController < BaseController
    get '/' do
        json({ 'hello': 'world' });
    end
end
