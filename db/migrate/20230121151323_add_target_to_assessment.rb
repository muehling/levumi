class AddTargetToAssessment < ActiveRecord::Migration[7.0]
  def change
    # Existierende Zeilen updaten!
    add_column :assessments, :target, :json

    # Neue Tabelle für Ziele pro Schüler*in und Test
    create_table :targets do |t|
      t.belongs_to :assessment, index: true
      t.belongs_to :student, index: true
      t.json :value
      t.timestamps
    end
  end
end
