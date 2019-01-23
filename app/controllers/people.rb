require_relative '../models/person.rb'

PeopleController = proc do
    helpers do
        def find(id)
            Person.with_pk(id.to_i)
        end

        def before_index
            params[:page][:number] = 1 if params[:page].empty?
        end
    end

    show do
        next resource
    end

    index do
        Person.dataset
    end

    has_many :roles do
        fetch do
            resource.roles_dataset
        end
    end
end
