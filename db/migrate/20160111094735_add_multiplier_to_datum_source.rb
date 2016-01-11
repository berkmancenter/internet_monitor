class AddMultiplierToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :multiplier, :float, default: 1.0
  end
end
