class AddProviderToDatumSource < ActiveRecord::Migration
  def change
    add_column :datum_sources, :provider_id, :integer
  end
end
