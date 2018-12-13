class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :label
      t.integer :user_id
      t.boolean :archive, default: false
      t.timestamps
    end
  end
end
