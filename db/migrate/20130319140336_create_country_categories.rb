class CreateCountryCategories < ActiveRecord::Migration
  def change
    create_table :country_categories do |t|
      t.references :country
      t.references :category
      t.float :score

      t.timestamps
    end
    add_index :country_categories, :country_id
    add_index :country_categories, :category_id
  end
end
