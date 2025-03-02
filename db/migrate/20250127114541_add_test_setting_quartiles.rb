class AddTestSettingQuartiles < ActiveRecord::Migration[7.2]
  def change
    add_column :tests, :allow_quartiles, :boolean, default: false
  end
end
