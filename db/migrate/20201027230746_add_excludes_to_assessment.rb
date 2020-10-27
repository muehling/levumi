class AddExcludesToAssessment < ActiveRecord::Migration[5.2]
  def change
    #Existierende Zeilen updaten!
    add_column :assessments, :excludes, :json
  end
end