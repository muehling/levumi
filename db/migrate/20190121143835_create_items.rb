class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.belongs_to :test, index: true, foreign_key: {on_delete: :cascade}
      t.string :shorthand
      t.string :description
      t.string :data
      t.timestamps
    end
  end
end
