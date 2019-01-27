require_relative '../models/path.rb'
require_relative '../helpers/page_caching.rb'

PathsController = proc do
    helpers PageCachingHelper do
        def get_include
            'archives'
        end
    end

    helpers do
        def find(id)
            Path.with_pk(id.to_i)
        end

        def before_index
            params[:page][:number] = 1 if params[:page].empty?
        end
    end

    show do
        next resource
    end

    index do
        Path.dataset
    end

    has_one :series do
        pluck do
            resource.series
        end
    end

    has_many :archives do
        fetch do
            resource.archives_dataset
        end
    end
end
