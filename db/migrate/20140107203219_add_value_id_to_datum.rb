class AddValueIdToDatum < ActiveRecord::Migration
  def change
    add_column :data, :value_id, :string
  end
end
