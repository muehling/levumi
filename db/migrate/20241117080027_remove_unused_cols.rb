class RemoveUnusedCols < ActiveRecord::Migration[7.2]
  def change
    remove_column :annotations, :trend_threshold # no longer supported
    remove_column :targets, :date_until # has been moved to the assessment settings
  end
end
