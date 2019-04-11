class CreateUsersAndGroups < ActiveRecord::Migration[5.2]
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

    create_table :groups do |t|
      t.string :label
      t.boolean :archive, default: false
      t.boolean :demo, default: false
      t.timestamps
    end

    create_table :group_shares do |t|
      t.boolean :owner
      t.boolean :read_only
      t.string :key
      t.belongs_to :user, index: true, foreign_key: {on_delete: :cascade}
      t.belongs_to :group, index: true, foreign_key: {on_delete: :cascade}
      t.timestamps
    end
  end
end
