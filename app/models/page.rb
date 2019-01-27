require 'sequel'

require_relative 'archive.rb'
require_relative 'serializer.rb'

class Page < Sequel::Model
    many_to_one :archive
end

class PageSerializer < Serializer
    attribute :path
    attribute :index
    attribute :image do "/pages/#{id}" end

    has_one :archive
end
