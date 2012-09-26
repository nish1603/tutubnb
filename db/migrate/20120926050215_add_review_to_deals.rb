class AddReviewToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :review, :boolean, :default => false
  end
end
