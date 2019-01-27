require_relative '../models/series.rb'
require_relative '../helpers/page_caching.rb'

SeriesController = proc do
    helpers PageCachingHelper do
        def get_include
            'paths.archives'
        end
    end

    helpers do
        def find(id)
            Series.with_pk(id.to_i)
        end

        def before_index
            params[:page][:number] = 1 if params[:page].empty?
        end
    end

    show do
        next resource
    end

    index do
        Series.dataset
    end

    has_many :paths do
        fetch do
            resource.paths_dataset
        end
    end

    has_many :genres do
        fetch do
            resource.genres_dataset
        end
    end

    has_many :categories do
        fetch do
            resource.categories_dataset
        end
    end

    has_many :staff do
        fetch do
            resource.staff_dataset
        end
    end

    has_many :series_relationships do
        fetch do
            resource.series_relationships_dataset
        end
    end
end
