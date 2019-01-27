require 'sinatra/base'
require 'sinatra/jsonapi'
require 'sinja/sequel/helpers'

require_relative 'series.rb'
require_relative 'series_relationships.rb'
require_relative 'genres.rb'
require_relative 'categories.rb'
require_relative 'people.rb'
require_relative 'staff.rb'
require_relative 'paths.rb'
require_relative 'archives.rb'
require_relative '../models/user.rb'
require_relative '../models/errors.rb'
require_relative '../utils/madokami.rb'

# activesupport pluralizes staff as staffs, so correct it
ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.irregular 'staff', 'staff'
end

class ApplicationController < Sinatra::Base
    register Sinatra::JSONAPI

    helpers do
        prepend Sinja::Sequel::Core

        def unauthorized
            raise UnauthorizedError.new
        end

        def madokami_image(path)
            # request the image
            Madokami.request path, token: @token do |r|
                case r.code
                    when '200'
                        # serve the image data
                        content_type r['Content-Type']
                        r.body
                    when '302', '401'
                        unauthorized
                    when '404'
                        not_found
                end
            end
        end
    end

    before do
        auth = Rack::Auth::Basic::Request.new(env)

        # verify that the basic auth is valid
        if auth.provided? and auth.basic? and auth.credentials
            username = auth.credentials.first
            password = auth.credentials.last

            # try to get a token for the user
            @token = User.get_token username, password
        else
            unauthorized
        end
    end

    # connect resources to their controllers
    resource :series, &SeriesController
    resource :series_relationships, &SeriesRelationshipsController
    resource :genres, &GenresController
    resource :categories, &CategoriesController
    resource :people, &PeopleController
    resource :staff, &StaffController
    resource :paths, &PathsController
    resource :archives, &ArchivesController

    get %r{/images/(i\d+\.(?:jpg|jpeg|png))} do
        name = params[:captures].first

        # verify that the image name is valid
        if Series.where(image: name).select(:image).any?
            # serve the image
            madokami_image "/images/#{name}"
        else
            not_found
        end
    end

    freeze_jsonapi
end
