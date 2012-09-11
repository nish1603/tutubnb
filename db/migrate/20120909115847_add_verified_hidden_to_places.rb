class AddVerifiedHiddenToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :verified, :boolean, :default => false
    add_column :places, :hidden, :boolean, :default => false
  end
end
