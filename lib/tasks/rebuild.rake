# Delete non-CMS data and re-import
# Does not re-create languages

require 'csv'

namespace :imon do
  desc 'Import Herdict Quick Stats data'
  task :herdictqs => [:environment] do |task|
    CSV.open(Rails.root.join('db', 'sources.csv'), :headers => true).each_with_index do |row, i|
        next unless row['Indicator'] == 'Herdict Quick Stats'
        Retriever.retrieve!(i + 1)
    end
  end

  desc 'Import Herdict data'
  task :herdict => [:environment] do |task|
    CSV.open(Rails.root.join('db', 'sources.csv'), :headers => true).each_with_index do |row, i|
        next unless row['Indicator'] == 'Herdict'
        Retriever.retrieve!(i + 1)
    end
  end

  desc 'Delete non-CMS data and re-import (does not rebuild Language)'
  task :rebuild => [:environment] do |task|
    # Delete old DatumSource, & Indicator data
    Indicator.delete_all
    DatumSource.delete_all

    # new groups (since last rebuild)
    Group.find_or_create_by_admin_name_and_public_name 'filtering_mo', 'Internet Filtering MO'

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
  end
end
