class AddCancelRequestAcceptToDeals < ActiveRecord::Migration
  def change
  	add_column :deals, :cancel, :boolean, default: false
  	add_column :deals, :accept, :boolean
  	add_column :deals, :request, :boolean, default: true
  end
end
