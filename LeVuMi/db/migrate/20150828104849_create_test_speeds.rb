class CreateTestSpeeds < ActiveRecord::Migration
  def change
    add_column :tests, :time, :integer
  end
end
