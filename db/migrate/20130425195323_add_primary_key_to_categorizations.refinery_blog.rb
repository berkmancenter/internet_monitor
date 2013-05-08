# This migration comes from refinery_blog (originally 20110803223529)
class AddPrimaryKeyToCategorizations < ActiveRecord::Migration
  def up
    unless Refinery::Categorization.column_names.include?("id")
      add_column Refinery::Categorization.table_name, :id, :primary_key
    end
  end

  def down
    if Refinery::Categorization.column_names.include?("id")
      remove_column Refinery::Categorization.table_name, :id
    end
  end
end

