class RemoveScoreFromCountryCategory < ActiveRecord::Migration
  def up
    remove_column :country_categories, :score
  end

  def down
    add_column :country_categories, :score, :float
  end
end
