class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.float :daily
      t.float :weekend
      t.float :weekly
      t.float :monthly
      t.integer :max_guests
      t.integer :add_guests
      t.float :add_price
      t.integer :place_id

      t.timestamps
    end
  end
end
