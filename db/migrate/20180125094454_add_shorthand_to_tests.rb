class AddShorthandToTests < ActiveRecord::Migration[5.0]
  def change
    add_column :tests, :shorthand, :string
  end
end
