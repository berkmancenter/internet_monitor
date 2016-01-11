class AddIndexNameToDatum < ActiveRecord::Migration
  def change
    add_column :data, :index_name, :string
  end
end
