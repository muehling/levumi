class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.integer :test_family_id
      t.string :level
      t.string :information

      t.timestamps
    end
  end
end
