Sequel.migration do
    change do
        create_table(:series) do
            primary_key :id
            Integer :mu_id, :null => false
            String :title, :null => false
            Integer :year, :null => false
            String :description, :text => true, :collate => 'BINARY'
            String :origin_status, :default => nil
            Bool :completely_scanlated, :default => false, :null => false
            String :image, :default => nil
            Time :created_at, :default => '0000-00-00 00:00:00', :null => false
            Time :updated_at, :default => '0000-00-00 00:00:00', :null => false
        end
    end
end
