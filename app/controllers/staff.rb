require_relative '../models/staff.rb'

StaffController = proc do
    helpers do
        def find(id)
            Staff.with_pk(id.to_i)
        end

        def before_index
            params[:page][:number] = 1 if params[:page].empty?
        end
    end

    show do
        next resource
    end

    index do
        Staff.dataset
    end

    has_one :person do
        pluck do
            resource.person
        end
    end

    has_one :series do
        pluck do
            resource.series
        end
    end
end
