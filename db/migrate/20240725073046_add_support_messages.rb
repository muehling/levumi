class AddSupportMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :support_messages do |t|
      t.string :subject
      t.string :sender
      t.text :message
      t.integer :status
      t.belongs_to :user, index: true, foreign_key: true
      t.string :updated_by
      t.text :comment
      t.timestamps
    end
  end
end
