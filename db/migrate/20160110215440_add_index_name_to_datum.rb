class AddIndexNameToDatum < ActiveRecord::Migration
  def change
    add_column :datum_sources, :in_index, :boolean, :default => false
    add_column :data, :index_name, :string
  end
end
