class AddDefaultWeightToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :default_weight, :float, :default => 1.0
  end
end
