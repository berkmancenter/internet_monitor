class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :admin_name
      t.string :public_name

      t.timestamps
    end

    add_column :datum_sources, :group_id, :integer
    add_index :datum_sources, :group_id
  end
end
