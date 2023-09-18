class ChangeAnnotationViewToId < ActiveRecord::Migration[7.0]
  def change
    change_column :annotations, :view, :text
  end
end
