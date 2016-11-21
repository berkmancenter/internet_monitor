class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :short_name
      t.string :url

      t.timestamps
    end
  end
end
