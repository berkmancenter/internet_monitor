class AddRegionToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :region, :boolean, default: false
  end
end
