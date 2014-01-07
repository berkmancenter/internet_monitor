class AddRequiresPageToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :requires_page, :boolean
  end
end
