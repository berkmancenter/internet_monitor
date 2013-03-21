class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.references :datum_source
      t.datetime :start_date
      t.references :country
      t.references :language
      t.float :original_value
      t.text :value
      t.string :type

      t.timestamps
    end
    add_index :data, :datum_source_id
    add_index :data, :country_id
    add_index :data, :language_id
  end
end
