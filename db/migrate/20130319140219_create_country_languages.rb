class CreateCountryLanguages < ActiveRecord::Migration
  def change
    create_table :country_languages do |t|
      t.references :country
      t.references :language

      t.timestamps
    end
    add_index :country_languages, :country_id
    add_index :country_languages, :language_id
  end
end
