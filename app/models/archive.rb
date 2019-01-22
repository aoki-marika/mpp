require 'sequel'

require_relative 'path.rb'
require_relative 'serializer.rb'

class Archive < Sequel::Model
    many_to_one :parent, class: :Path
end

class ArchiveSerializer < Serializer
    attribute :path
    attribute :size
    attribute :created_at
    attribute :updated_at

    has_one :parent
end
