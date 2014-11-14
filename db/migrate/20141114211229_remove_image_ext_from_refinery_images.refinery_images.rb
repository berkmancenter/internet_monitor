# This migration comes from refinery_images (originally 20120625093918)
class RemoveImageExtFromRefineryImages < ActiveRecord::Migration
  def up
    remove_column :refinery_images, :image_ext
  end

  def down
    add_column :refinery_images, :image_ext, :string
  end
end
