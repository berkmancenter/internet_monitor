object @datum

child :country => :country do 
    attributes :id, :name
end

child :language => :language do 
    attributes :id, :name
end

attributes :start_date

node :value do |datum|
    JSON.parse(datum.value)
end
