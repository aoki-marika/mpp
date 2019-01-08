require 'sinatra/base'

module Routes
    class AppController < Sinatra::Base
        configure :production, :development do
            enable :logging
        end
    end
end
