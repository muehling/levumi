class AddUploaderToTest < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :updated_by, :string
  end
end
