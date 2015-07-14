class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :email
      t.text :password_digest
      t.text :name
      t.text :school
      t.timestamps
    end
  end
end
