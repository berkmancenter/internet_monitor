# This migration comes from seo_meta (originally 20120518234749)
if Gem.loaded_specs["activerecord"].version >= Gem::Version.new('5.0')
  class RemoveMetaKeywordsFromSeoMeta < ActiveRecord::Migration[4.2]; end
else
  class RemoveMetaKeywordsFromSeoMeta < ActiveRecord::Migration; end
end

RemoveMetaKeywordsFromSeoMeta.class_eval do
  def up
    remove_column :seo_meta, :meta_keywords
  end

  def down
    add_column :seo_meta, :meta_keywords, :string
  end
end
