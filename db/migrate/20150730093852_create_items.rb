class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :test_id
      t.text :text
      t.integer :difficulty
      t.integer :type

      t.timestamps
    end
  end
end
