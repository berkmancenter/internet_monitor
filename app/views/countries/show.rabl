object @country
attributes :id, :name, :description, :score
attributes :iso_code => :iso_code_2, :iso3_code => :iso_code_3
child :most_recent_indicators, :object_root => false do 
    glue :source do
        attributes :id => :source_id
        attributes :default_weight
    end
    attributes :name
    attributes :start_date => :date, :original_value => :value, :value => :normalized_value
end
