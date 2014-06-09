class AddDisplayOriginalToDatumSources < ActiveRecord::Migration
  def change
    add_column :datum_sources, :display_original, :boolean, default: true
  end
end
