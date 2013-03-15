# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
categories = ['Access', 'Activity', 'Control'].map{|n| Category.find_or_create_by_name(n)}

CSV.open(Rails.root.join('db','iso-639-3_20130123.tab'), {:col_sep => "\t", :headers => true}).each do |line|
    Language.create(:name => line['Ref_Name'], :iso_code => (line['Part1'] || line['Id']))
    puts line['Ref_Name']
end

CSV.open(Rails.root.join('db', 'countryInfo.txt'), {:headers => true, :col_sep => "\t"}).each do |line|
    country = Country.find_or_create_by_iso_code(:iso_code => line['ISO'], :name => line['Country'])
    country.categories = categories
    puts "#{country.name}: #{line['Languages']}"
    unless line['Languages'].nil?
        line['Languages'].split(',').each do |language|
            country.languages << Language.find_by_iso_code(language[0,2])
        end
    end
end

type_map = {'number', 'text', 'multiple URLs', 'URL', 'XML'}
CSV.open(Rails.root.join('db', 'sources.csv'), :headers => true).each do |line|
    next unless line['In IM Index?'][0] == 'y'
    DatumSource.create(:administrative_name => line['Indicator'], :public_name => line['Indicator'], :type => type_map[line['Data type']], :is_api => !line['API available?'].empty?)
end
