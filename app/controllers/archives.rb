require_relative '../models/archive.rb'
require_relative '../helpers/page_caching.rb'

ArchivesController = proc do
    helpers PageCachingHelper

    helpers do
        def find(id)
            Archive.with_pk(id.to_i)
        end

        def before_index
            params[:page][:number] = 1 if params[:page].empty?
        end
    end

    show do
        next resource
    end

    index do
        Archive.dataset
    end

    has_one :parent do
        pluck do
            resource.parent
        end
    end

    has_many :pages do
        fetch do
            resource.cache_pages(@token)
            resource.pages_dataset
        end
    end
end
