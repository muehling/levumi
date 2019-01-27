class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :label
      t.belongs_to :user, index: true, foreign_key: {on_delete: :cascade}
      t.boolean :archive, default: false
      t.boolean :demo, default: false
      t.timestamps
    end
  end
end
