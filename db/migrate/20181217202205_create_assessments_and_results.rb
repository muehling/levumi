class CreateAssessmentsAndResults < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments do |t|
      t.belongs_to :group, index: true
      t.belongs_to :test, index: true
      t.boolean :active, default: true
      t.timestamps
    end

    create_table :results do |t|
      t.belongs_to :student, index: true
      t.belongs_to :assessment, index: true
      t.references :prior_result
      t.date :test_date
      t.date :test_week
      t.json :views
      t.json :report
      t.json :data
      t.timestamps
    end

    #Tabelle für anonymiserte Altdaten
    create_table :shadow_results do |t|
      t.belongs_to :shadow_student, index: true
      t.string :shorthand
      t.integer :version
      t.integer :group
      t.date :test_date
      t.date :test_week
      t.json :views
      t.json :report
      t.json :data
      t.timestamps
    end
  end
end
