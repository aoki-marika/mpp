require_relative '../models/series_relationship.rb'

SeriesRelationshipsController = proc do
    helpers do
        def find(id)
            SeriesRelationship.with_pk(id.to_i)
        end

        def before_index
            params[:page][:number] = 1 if params[:page].empty?
        end
    end

    show do
        next resource
    end

    index do
        SeriesRelationship.dataset
    end

    has_one :source do
        pluck do
            resource.source
        end
    end

    has_one :destination do
        pluck do
            resource.destination
        end
    end
end
