# This migration comes from refinery_blog (originally 20120227022021)
class AddSlugToPostsAndCategories < ActiveRecord::Migration
  def change
    add_column Refinery::Blog::Post.table_name, :slug, :string
    add_index Refinery::Blog::Post.table_name, :slug

    add_column Refinery::Blog::Category.table_name, :slug, :string
    add_index Refinery::Blog::Category.table_name, :slug
  end
end