class AddSourceInfoToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :source_name, :string
    add_column :datum_sources, :source_link, :string
    remove_column :datum_sources, :link
  end
end
