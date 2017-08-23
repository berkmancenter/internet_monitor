# This migration comes from refinery_images (originally 20140814073957)
class AddTitleAndAltToRefineryImages < ActiveRecord::Migration
  def change
    change_table :refinery_images do |t|
      t.string :image_title
      t.string :image_alt
    end
  end
end
