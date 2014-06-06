class ChangeNormalizedDefaultOnDatumSource < ActiveRecord::Migration
  def change
    change_column_default( :datum_sources, :normalized, false )
  end
end
