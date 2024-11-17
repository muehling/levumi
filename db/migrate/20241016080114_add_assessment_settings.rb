class AddAssessmentSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :assessments, :settings, :json
  end
end
