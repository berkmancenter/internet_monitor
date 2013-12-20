# Delete non-CMS data and re-import
# Does not re-create languages

require 'csv'

namespace :imon do
  desc 'Delete non-CMS data and re-import (does not rebuild Language)'
  task :rebuild => [:environment] do |task|
    # Delete old Country, CountryCategory, CountryLanugage, DatumSource, & Indicator data

    Indicator.delete_all
    DatumSource.delete_all
    CountryCategory.delete_all
    CountryLanguage.delete_all
    Country.delete_all

    categories = Category.all

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

    # Import all the data
    CSV.open(Rails.root.join('db', 'sources.csv'), :headers => true).each_with_index do |row, i|
        next unless row['Include in Internet Monitor?'] == 'y'
        Retriever.retrieve!(i + 1)
    end

    Country.all.each do |country|
        country.recalc_scores!
    end
  end
end
