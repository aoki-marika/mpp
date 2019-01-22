require 'sinatra/base'
require 'sinatra/jsonapi'
require 'sinja/sequel/helpers'

require_relative 'series.rb'
require_relative 'genres.rb'
require_relative '../models/user.rb'
require_relative '../models/errors.rb'
require_relative '../utils/madokami.rb'

class ApplicationController < Sinatra::Base
    register Sinatra::JSONAPI

    helpers do
        prepend Sinja::Sequel::Core
    end

    before do
        # authenticate every route in the application
        auth = Rack::Auth::Basic::Request.new(request.env)

        # called when the credentials are invalid
        def unauthorized
            raise UnauthorizedError.new
        end

        if auth.provided? and auth.basic? and auth.credentials
            username = auth.credentials.first
            password = auth.credentials.last

            if user = User.first(name: username)
                # verify the credentials against the db
                if password == user.password
                    pass
                else
                    unauthorized
                end
            else
                # verify the credentials against madokami
                Madokami.request '/', username, password do |r|
                    if r.code == '200'
                        # the credentials are valid, register the user and allow access
                        User.create(name: username, password: password)
                        pass
                    else
                        unauthorized
                    end
                end
            end
        else
            unauthorized
        end
    end

    # connect resources to their controllers
    resource :series, &SeriesController
    resource :genres, &GenresController

    freeze_jsonapi
end
