require 'sqlite3'

require_relative '../app/models/related_type.rb'

# pass the madokami db first and the mpp db second
source = ARGV[0]
destination = ARGV[1]

# connect and attach both databases
$db = SQLite3::Database.new ':memory:'
$db.execute 'ATTACH DATABASE ? AS source', source
$db.execute 'ATTACH DATABASE ? AS destination', destination

# series
# todo: remove 'From [source]:' and `Note:` from description, potentially move note into it's own column
$db.execute <<-SQL
    INSERT INTO destination.series
        SELECT id, mu_id, name, year, description, origin_status, IFNULL(scan_status, 0), image, created_at, updated_at
        FROM source.series;
SQL

$db.execute 'UPDATE destination.series SET completely_scanlated = 1 WHERE completely_scanlated = "Yes"';
$db.execute 'UPDATE destination.series SET completely_scanlated = 0 WHERE completely_scanlated = "No"';

# related series
$db.execute <<-SQL
    INSERT INTO destination.related_series
        SELECT id, series_id, related_mu_id, type
        FROM source.related_series;
SQL

# find the old type and replace it with the new type in the related series table
def replace_related_type(old, new)
    $db.execute "UPDATE destination.related_series SET type = ? WHERE type = ?", new, old;
end

# related series types
replace_related_type 'Main Story', RelatedType::MAIN_STORY
replace_related_type 'Adapted From', RelatedType::ADAPTED_FROM
replace_related_type 'Alternate Story', RelatedType::ALTERNATE_STORY
replace_related_type 'Spin-Off', RelatedType::SPIN_OFF
replace_related_type 'Side Story', RelatedType::SIDE_STORY
replace_related_type 'Prequel', RelatedType::PREQUEL
replace_related_type 'Sequel', RelatedType::SEQUEL

# paths
$db.execute <<-SQL
    INSERT INTO destination.paths
        SELECT id, series_id, path
        FROM source.path_records
        WHERE directory = 1;
SQL

# archives
$db.execute <<-SQL
    INSERT INTO destination.archives
        SELECT id, parent_id, path, size, created_at, updated_at
        FROM source.path_records
        WHERE directory = 0;
SQL

# insert facets of the given type(s) into the given table
def insert_facet(table, type, second_type = nil)
    second_condition = second_type == nil ? nil : "OR type = '#{second_type}'"

    $db.execute <<-SQL
        INSERT INTO destination.#{table}
            SELECT id, name, created_at, updated_at
            FROM source.facets
            INNER JOIN (SELECT facet_id, type FROM source.facet_series)
            AS facet_series
            ON (facet_series.facet_id = source.facets.id)
            WHERE type = '#{type}' #{second_condition}
            GROUP BY name;
    SQL
end

# insert facet -> series records of the given type into the given table
def insert_facet_series(table, type)
    $db.execute <<-SQL
        INSERT INTO destination.#{table}
            SELECT facet_id, series_id
            FROM facet_series
            WHERE type = '#{type}';
    SQL
end

# associated titles
insert_facet('associated_titles', 'title')
insert_facet_series('associated_titles_series', 'title')

# genres
insert_facet('genres', 'genre')
insert_facet_series('genres_series', 'genre')

# categories
insert_facet('categories', 'category')
insert_facet_series('categories_series', 'category')

# people
insert_facet('people', 'artist', 'author')
insert_facet_series('artists_series', 'artist')
insert_facet_series('authors_series', 'author')

# there are lots of title facets that are the same as their series' title, so remove those
$db.execute 'PRAGMA foreign_keys = ON'
$db.execute <<-SQL
    DELETE FROM destination.associated_titles
        WHERE name IN (SELECT title FROM destination.series)
SQL
