class AddApiEndpointToDatumSources < ActiveRecord::Migration
  def change
    add_column :datum_sources, :api_endpoint, :string
  end
end
