class AddCompleteToDeals < ActiveRecord::Migration
  def change
  	add_column :deals, :complete, :boolean, :default => false
  end
end
