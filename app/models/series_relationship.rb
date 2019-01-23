require 'sequel'

require_relative 'series.rb'
require_relative 'series_relationship_type.rb'
require_relative 'serializer.rb'

class SeriesRelationship < Sequel::Model
    many_to_one :source, key: :source_id, class: :Series
    many_to_one :destination, key: :destination_id, class: :Series
end

class SeriesRelationshipSerializer < Serializer
    attribute :type do
        case object.type
            when SeriesRelationshipType::MAIN_STORY
                'main_story'
            when SeriesRelationshipType::ADAPTATION
                'adaptation'
            when SeriesRelationshipType::ALTERNATE_STORY
                'alternate_story'
            when SeriesRelationshipType::SPIN_OFF
                'spinoff'
            when SeriesRelationshipType::SIDE_STORY
                'side_story'
            when SeriesRelationshipType::PREQUEL
                'prequel'
            when SeriesRelationshipType::SEQUEL
                'sequel'
        end
    end

    has_one :source
    has_one :destination
end
