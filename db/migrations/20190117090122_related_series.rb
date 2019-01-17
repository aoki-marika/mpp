Sequel.migration do
    change do
        create_table(:related_series) do
            primary_key :id
            foreign_key :series_id, :series, :null => false
            Integer :related_mu_id, :null => false
            Integer :type, :null => false

            index [:series_id]
        end
    end
end

