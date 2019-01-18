Sequel.migration do
    change do
        create_table(:archives) do
            primary_key :id
            foreign_key :path_id, :paths, :index => true, :default => nil
            String :path, :size => 4096, :null => false
            Integer :size, :null => false
            Time :created_at, :default => '0000-00-00 00:00:00', :null => false
            Time :updated_at, :default => '0000-00-00 00:00:00', :null => false
        end
    end
end

