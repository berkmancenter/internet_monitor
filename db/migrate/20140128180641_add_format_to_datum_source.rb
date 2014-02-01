class AddFormatToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :in_category_page, :boolean
    add_column :datum_sources, :display_prefix, :string
    add_column :datum_sources, :display_suffix, :string
    add_column :datum_sources, :precision, :integer
  end
end
