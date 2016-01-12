class AddInvertToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :invert, :boolean, default: false
  end
end
