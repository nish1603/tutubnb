class AddSecretToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :secret, :string
  end
end
