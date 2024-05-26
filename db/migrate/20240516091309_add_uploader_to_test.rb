class AddUploaderToTest < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :updated_by, :string
    add_column :tests, :responsible, :string
  end
end
