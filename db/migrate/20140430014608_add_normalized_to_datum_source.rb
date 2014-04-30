class AddNormalizedToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :normalized, :boolean, :default => true
  end
end
