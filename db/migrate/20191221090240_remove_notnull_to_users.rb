class RemoveNotnullToUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :height,:float, null: true
  end

  def down
    change_column :users, :height,:float, null: false
  end
end
