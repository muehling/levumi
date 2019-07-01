class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :login
      t.belongs_to :group, index: true
      t.integer :gender
      t.date :birthmonth
      t.integer :sen
      t.boolean :migration
      t.string :settings
      t.timestamps
    end

    #Tabelle für anonymiserte Altdaten
    create_table :shadow_students do |t|
      t.integer :original_id, index: true
      t.integer :group
      t.integer :gender
      t.date :birthmonth
      t.integer :sen
      t.boolean :migration
      t.timestamps
    end
  end
end
