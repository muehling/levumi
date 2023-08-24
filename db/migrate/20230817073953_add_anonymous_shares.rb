class AddAnonymousShares < ActiveRecord::Migration[7.0]
  def change
    add_column :group_shares, :is_anonymous, :boolean
  end
end
