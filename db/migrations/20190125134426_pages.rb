Sequel.migration do
    change do
        create_table(:pages) do
            primary_key :id
            foreign_key :archive_id, :archives, :index => true, :default => nil
            String :path, :size => 4096, :null => false
            Integer :index, :null => false
        end
    end
end

