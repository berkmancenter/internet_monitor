class AddNormalizedColumnToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :normalized_name, :string
  end
end
