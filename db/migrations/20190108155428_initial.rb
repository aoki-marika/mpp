require 'sequel'

Sequel.migration do
    change do
        create_table(:users) do
            primary_key :id
            String :name, :unique => true, :null => false
            String :password, :null => false
        end
    end
end
