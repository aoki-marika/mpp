Sequel.migration do
    change do
        drop_table(:related_series)

        create_table(:series_relationships) do
            primary_key :id
            foreign_key :source_id, :series, :index => true, :null => false
            foreign_key :destination_id, :series, :index => true, :null => false
            Integer :type, :null => false
        end
    end
end
