collection @datum_sources, :root => :datum_sources, :object_root => false
attributes :id
attributes :public_name => :name
attributes :description
attributes :min, :max, :default_weight, :if => lambda { |source| source.datum_type == 'Indicator' }
attributes :datum_type => :type
glue :category do
    attributes :name => :category
end
