class CreateTestMcs < ActiveRecord::Migration
  def change
    add_column :tests, :answers, :text
  end
end
