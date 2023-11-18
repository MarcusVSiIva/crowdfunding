class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string, default: 'user'
    add_column :users, :active, :boolean, default: true
  end
end
