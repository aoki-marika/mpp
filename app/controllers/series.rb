require_relative '../models/series.rb'

SeriesController = proc do
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

    has_many :artists do
        fetch do
            resource.artists_dataset
        end
    end

    has_many :authors do
        fetch do
            resource.authors_dataset
        end
    end
end
