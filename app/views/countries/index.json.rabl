collection @scored_countries
cache @scored_countries
attributes :id, :name, :score
child :indicators_affecting_score, :object_root => false do 
    glue :source do
        attributes :id => :source_id
        glue :category do
            attributes :name => :category
        end
        glue :group do
            attributes :admin_name => :group
        end
    end
    attributes :original_value => :value, :value => :normalized_value
end
