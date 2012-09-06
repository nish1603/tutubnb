class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title
      t.text :description
      t.string :property_type
      t.string :room_type
      t.float :daily
      t.float :weekend
      t.float :weekly 
      t.float :monthly
      t.integer :add_guests, default: 0
      t.float :add_price, default: 0.00
      t.integer :user_id

      t.timestamps
    end
  end
end
