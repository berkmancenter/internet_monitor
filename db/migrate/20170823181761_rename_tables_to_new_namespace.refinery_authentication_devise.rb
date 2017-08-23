# This migration comes from refinery_authentication_devise (originally 20150503125200)
class RenameTablesToNewNamespace < ActiveRecord::Migration
  def change
    remove_index :refinery_user_plugins, [:user_id, :name]
    add_index :refinery_user_plugins, [:user_id, :name], unique: true,
              name: :refinery_user_plugins_user_id_name

    remove_index :refinery_roles_users, [:role_id, :user_id]
    remove_index :refinery_roles_users, [:user_id, :role_id]
    add_index :refinery_roles_users, [:role_id, :user_id], name: :refinery_roles_users_role_id_user_id
    add_index :refinery_roles_users, [:user_id, :role_id], name: :refinery_roles_users_user_id_role_id

    rename_table :refinery_users, :refinery_authentication_devise_users
    rename_table :refinery_roles, :refinery_authentication_devise_roles
    rename_table :refinery_user_plugins, :refinery_authentication_devise_user_plugins
    rename_table :refinery_roles_users, :refinery_authentication_devise_roles_users
  end
end
