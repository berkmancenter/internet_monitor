collection @countries
cache @countries
attributes :id, :name, :score
child :most_recent_indicators, :object_root => false do 
    glue :source do
        attributes :id => :source_id
        glue :category do
            attributes :name => :category
        end
    end
    attributes :original_value => :value, :value => :normalized_value
end
