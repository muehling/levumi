class AddTargetToAssessment < ActiveRecord::Migration[7.0]
  def change
    # Neue Tabelle für Ziele pro Schüler*in und Test
    create_table :targets do |t|
      t.belongs_to :assessment, index: true
      t.belongs_to :student, index: true
      t.json :view
      t.string :value
      t.date :date_until
      t.string :deviation
      t.timestamps
    end
  end
end
