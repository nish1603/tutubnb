class AddWalletAdminActivationLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wallet, :float, :default => 0.0
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :activation_link, :string
  end
end
