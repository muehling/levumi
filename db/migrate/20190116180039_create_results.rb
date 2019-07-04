class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.belongs_to :student, index: true
      t.belongs_to :assessment, index: true
      t.references :prior_result
      t.date :test_date
      t.date :test_week
      t.text :results
      t.text :data
      t.timestamps
    end

    #Tabelle für anonymiserte Altdaten
    create_table :shadow_results do |t|
      t.belongs_to :shadow_student, index: true
      t.integer :test
      t.date :test_date
      t.date :test_week
      t.text :results
      t.text :data
      t.timestamps
    end
  end
end
