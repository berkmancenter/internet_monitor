# This migration comes from refinery_blog (originally 20110803223526)
class AddCachedSlugs < ActiveRecord::Migration
  def change
    add_column Refinery::Blog::Category.table_name, :cached_slug, :string
    add_column Refinery::Blog::Post.table_name, :cached_slug, :string
  end
end
