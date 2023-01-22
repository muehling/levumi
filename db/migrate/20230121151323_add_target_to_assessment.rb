class AddTargetToAssessment < ActiveRecord::Migration[7.0]
  def change
    #Existierende Zeilen updaten!
    add_column :assessments, :target, :json
  end
end
