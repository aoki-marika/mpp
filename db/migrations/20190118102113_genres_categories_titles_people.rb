Sequel.migration do
    change do
        def create_model_table(name)
            create_table(name) do
                primary_key :id
                String :name, :null => false
                Time :created_at, :default => '0000-00-00 00:00:00', :null => false
                Time :updated_at, :default => '0000-00-00 00:00:00', :null => false
            end
        end

        def create_relation_table(name, model_key_name, model_table_name)
            create_table(name) do
                foreign_key model_key_name, model_table_name, :on_delete => :cascade, :index => true, :null => false
                foreign_key :series_id, :series, :index => true, :null => false
            end
        end

        # associated titles
        create_model_table(:associated_titles)
        create_relation_table(:associated_titles_series, :associated_title_id, :associated_titles)

        # genres
        create_model_table(:genres)
        create_relation_table(:genres_series, :genre_id, :genres)

        # categories
        create_model_table(:categories)
        create_relation_table(:categories_series, :category_id, :categories)

        # people
        create_model_table(:people)

        # artists
        create_relation_table(:artists_series, :person_id, :people)

        # authors
        create_relation_table(:authors_series, :person_id, :people)
    end
end

