class CreateType < ActiveRecord::Migration[7.0]
  def change
    create_table :types do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end

    add_reference :tests, :type, foreign_key: true
  end
end
