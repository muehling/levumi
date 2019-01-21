class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.belongs_to :test, index: true, foreign_key: true
      t.string :shorthand

      t.timestamps
    end
  end
end
