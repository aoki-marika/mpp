require_relative '../models/category.rb'

CategoriesController = proc do
    helpers do
        def find(id)
            Category.with_pk(id.to_i)
        end

        def before_index
            params[:page][:number] = 1 if params[:page].empty?
        end
    end

    show do
        next resource
    end

    index do
        Category.dataset
    end

    has_many :series do
        fetch do
            resource.series_dataset
        end
    end
end
