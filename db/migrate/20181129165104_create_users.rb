class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :security_digest
      t.string :capabilities
      t.datetime :last_login
      t.integer :account_type
      t.integer :state
      t.integer :institution
      t.string :town
      t.integer :school_type
      t.integer :focus
      t.datetime :tc_accepted
      t.integer :intro_state, default: 0
      t.timestamps
    end
  end
end
