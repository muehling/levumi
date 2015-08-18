class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :test_id
      t.text :description
      t.integer :difficulty
      t.integer :itemtype

      t.timestamps
    end
  end
end
