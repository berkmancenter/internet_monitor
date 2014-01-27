class AddRankToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :rank, :integer
  end
end
