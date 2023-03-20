class ChangeAnnotationTextToRelation < ActiveRecord::Migration[7.0]
  def change
    add_reference :annotations, :annotation_category
    remove_column :annotations, :content
  end
end
