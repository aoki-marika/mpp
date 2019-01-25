Sequel.migration do
    change do
        create_table(:tokens) do
            foreign_key :user_id, :users, :index => true, :null => false
            String :value, :null => false
            Time :expiration, :null => false
        end
    end
end
