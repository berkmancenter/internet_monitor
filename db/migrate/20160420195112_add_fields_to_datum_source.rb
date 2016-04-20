class AddFieldsToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :short_name, :string
    add_column :datum_sources, :display_class, :string
  end
end
