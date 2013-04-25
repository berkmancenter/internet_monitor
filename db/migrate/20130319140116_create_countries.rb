class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :iso_code
      t.string :iso3_code
      t.float :score
      t.text :description
      t.integer :indicator_count

      t.timestamps
    end
  end
end
