object @datum

child :country => :country do 
    attributes :id, :name
end

child :language => :language do 
    attributes :id, :name
end

attributes :start_date, :value
