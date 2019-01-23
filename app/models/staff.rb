require 'sequel'

require_relative 'person.rb'
require_relative 'series.rb'
require_relative 'staff_role.rb'
require_relative 'serializer.rb'

class Staff < Sequel::Model(:staff)
    many_to_one :person
    many_to_one :series
end

class StaffSerializer < Serializer
    attribute :role do
        case object.role
            when StaffRole::ARTIST
                'artist'
            when StaffRole::AUTHOR
                'author'
        end
    end

    has_one :person
    has_one :series
end
