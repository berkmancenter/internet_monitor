# This migration comes from refinery_blog (originally 20110803223527)
class AddCustomUrlFieldToBlogPosts < ActiveRecord::Migration
  def change
    add_column Refinery::Blog::Post.table_name, :custom_url, :string
  end
end
