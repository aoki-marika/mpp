require 'sequel'

require_relative 'page.rb'
require_relative 'path.rb'
require_relative 'serializer.rb'
require_relative '../utils/madokami.rb'

class Archive < Sequel::Model
    one_to_many :pages

    many_to_one :parent, class: :Path

    # Cache the pages for this archive into the database, using the given token to authenticate.
    def cache_pages(token)
        # if there are any pages then theyre already cached, so return
        if pages.any?
            return
        end

        # get the pages for this archive
        pages = Madokami.get_pages(self.path, token)
        pages.each { |p| p[:archive_id] = self.id }

        # add them to them db
        Page.multi_insert(pages)
    end
end

class ArchiveSerializer < Serializer
    attribute :path
    attribute :size
    attribute :created_at
    attribute :updated_at

    has_one :parent
    has_many :pages
end
