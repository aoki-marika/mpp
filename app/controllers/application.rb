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
            raise UnauthorizedError.new
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

        redirect "https://manga.madokami.al/images/#{name}", 303
    end

    freeze_jsonapi
end
