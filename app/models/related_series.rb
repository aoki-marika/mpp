require 'sequel'

require_relative 'series.rb'
require_relative 'related_type.rb'
require_relative 'serializer.rb'

class RelatedSeries < Sequel::Model
    # todo: change how related series work so that they have a 'series_relationships' table that has a source and destination foreign key column
    many_to_one :series
end

class RelatedSeriesSerializer < Serializer
    attribute :type do
        case object.type
            when RelatedType::MAIN_STORY
                'main-story'
            when RelatedType::ADAPTED_FROM
                'adapted-from'
            when RelatedType::ALTERNATE_STORY
                'spin-off'
            when RelatedType::SPIN_OFF
                'side-story'
            when RelatedType::SIDE_STORY
                'prequel'
            when RelatedType::PREQUEL
                'sequel'
            when RelatedType::SEQUEL
        end
    end

    has_one :series
end
