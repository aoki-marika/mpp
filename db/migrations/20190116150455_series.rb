Sequel.migration do
    change do
        create_table(:series) do
            primary_key :id
            Integer :mu_id, :null => false
            String :name, :null => false
            String :path, :size => 4096, :null => false
            Integer :year, :null => false
            String :description, :text => true, :collate => 'BINARY'
            String :origin_status, :default => nil
            String :scan_status, :default => nil
            String :image, :default => nil
            Time :created_at, :default => '0000-00-00 00:00:00', :null => false
            Time :updated_at, :default => '0000-00-00 00:00:00', :null => false
        end
    end
end
