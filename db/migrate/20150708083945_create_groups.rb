class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.text :name
      t.integer :user_id

      t.timestamps
    end
  end
end
