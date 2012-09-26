class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title
      t.text :description
      t.integer :property_type
      t.integer :room_type
      t.float :daily
      t.float :weekend
      t.float :weekly 
      t.float :monthly
      t.integer :add_guests
      t.float :add_price
      t.integer :user_id

      t.timestamps
    end
  end
end
