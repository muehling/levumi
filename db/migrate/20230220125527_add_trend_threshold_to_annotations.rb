class AddTrendThresholdToAnnotations < ActiveRecord::Migration[7.0]
  def change
    add_column :annotations, :trend_threshold, :boolean
  end
end
