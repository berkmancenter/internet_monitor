# This migration comes from refinery_resources (originally 20150430180959)
class AddTranslatedTitleToRefineryResources < ActiveRecord::Migration
  def self.up
    Refinery::Resource.create_translation_table!({
      resource_title: :string
    })
  end

  def self.down
    Refinery::Resource.drop_translation_table!
  end
end