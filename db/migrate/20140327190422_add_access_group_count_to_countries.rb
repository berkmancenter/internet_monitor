class AddAccessGroupCountToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :access_group_count, :integer
  end
end
