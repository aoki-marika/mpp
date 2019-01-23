Sequel.migration do
    change do
        drop_table(:artists_series, :authors_series)

        create_table(:staff) do
            primary_key :id
            foreign_key :person_id, :people, :index => true, :null => false
            foreign_key :series_id, :series, :index => true, :null => false
            Integer :role, :null => false
        end
    end
end
