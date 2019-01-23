require 'sequel'

require_relative 'series.rb'
require_relative 'serializer.rb'

class Person < Sequel::Model
    one_to_many :roles, class: :Staff
end

class PersonSerializer < Serializer
    attribute :name

    has_many :roles
end
