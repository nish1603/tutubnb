class AddWalletAdminActivationLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wallet, :float
    add_column :users, :admin, :boolean
    add_column :users, :activation_link, :string
  end
end
