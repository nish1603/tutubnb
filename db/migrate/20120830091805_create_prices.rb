class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.float :daily
      t.float :weekend, default: 0.00
      t.float :weekly, default: 0.00 
      t.float :monthly, default: 0.00
      t.integer :max_guests
      t.integer :add_guests, default: 0
      t.float :add_price, default: 0.00
      t.integer :place_id

      t.timestamps
    end
  end
end
