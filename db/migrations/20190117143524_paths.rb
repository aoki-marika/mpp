Sequel.migration do
    change do
        create_table(:paths) do
            primary_key :id
            foreign_key :series_id, :series, :index => true, :default => nil
            String :path, :size => 4096, :null => false
        end
    end
end

