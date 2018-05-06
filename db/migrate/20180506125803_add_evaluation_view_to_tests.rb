class AddEvaluationViewToTests < ActiveRecord::Migration[5.0]
  def change
    add_column :tests, :evaluation_view, :string
  end
end
