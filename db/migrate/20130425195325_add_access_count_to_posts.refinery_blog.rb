# This migration comes from refinery_blog (originally 20120223022021)
class AddAccessCountToPosts < ActiveRecord::Migration
  def change
    add_column Refinery::Blog::Post.table_name, :access_count, :integer, :default => 0
    
    add_index Refinery::Blog::Post.table_name, :access_count
    
  end
end