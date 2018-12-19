class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.string :name
      t.integer :competence_id
      t.string :level
      t.string :information

      t.timestamps
    end
  end
end
