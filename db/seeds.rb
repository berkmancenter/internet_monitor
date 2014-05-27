# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

# Create categories
categories = ['Access', 'Control', 'Activity'].map{|n| Category.find_or_create_by_name(n)}

# groups
Group.find_or_create_by_admin_name_and_public_name 'adoption', 'Adoption'
Group.find_or_create_by_admin_name_and_public_name 'speed', 'Speed and Quality'
Group.find_or_create_by_admin_name_and_public_name 'price', 'Price'
Group.find_or_create_by_admin_name_and_public_name 'human', 'Literacy and Gender Equality'

Group.find_or_create_by_admin_name_and_public_name 'control', 'Internet Control'
Group.find_or_create_by_admin_name_and_public_name 'filtering', 'Internet Filtering'
Group.find_or_create_by_admin_name_and_public_name 'filtering_mo', 'Internet Filtering MO'

# Create Lanuages
CSV.open(Rails.root.join('db','iso-639-3_20130123.tab'), {:col_sep => "\t", :headers => true}).each do |line|
    Language.create(:name => line['Ref_Name'], :iso_code => (line['Part1'] || line['Id']))
end

# Create countries and connect to languages
CSV.open(Rails.root.join('db', 'countryInfo.txt'), {:headers => true, :col_sep => "\t"}).each do |line|
    country = Country.find_or_initialize_by_iso_code(:iso_code => line['ISO'], :name => line['Country'], :iso3_code => line['ISO3'])
    country.categories = categories
    unless line['Languages'].nil?
        line['Languages'].split(',').each do |language|
            country.languages << Language.find_by_iso_code(language.split('-')[0])
        end
    end
    country.save!
end

# Import country bboxen

import_country_bboxes 'db/data_files/country_bbox.json'

# Import all the data
CSV.open(Rails.root.join('db', 'sources.csv'), :headers => true).each_with_index do |row, i|
    next unless row['Include in Internet Monitor?'] == 'y'
    Retriever.retrieve!(i + 1)
end

puts 'Country.count_indicators'
Country.count_indicators!

puts 'DatumSource.recalc_min_max_and_values!'
DatumSource.recalc_min_max_and_values!

puts 'Country.calculate_scores_and_rank!'
Country.calculate_scores_and_rank!

# Added by Refinery CMS Pages extension
Refinery::Pages::Engine.load_seed

# Added by Refinery CMS Blog engine
Refinery::Blog::Engine.load_seed
