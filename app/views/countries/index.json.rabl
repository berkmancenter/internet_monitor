collection @scored_countries => :cs
cache @scored_countries
attributes :id
attributes :name => :n
attributes :score => :s
child :indicators_affecting_score, :object_root => false do 
    glue :source do
        attributes :id => :sid
        attributes :default_weight => :dw
        glue :category do
            attributes :name => :c
        end
        glue :group do
            attributes :admin_name => :g
        end
    end
    attributes :original_value => :v, :value => :nv
end
