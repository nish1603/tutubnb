class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title
      t.text :description
      t.integer :property_type
      t.integer :room_type
      t.float :daily_price
      t.float :weekend_price
      t.float :weekly_price
      t.float :monthly_price
      t.integer :additional_guests
      t.float :additional_price
      t.integer :user_id

      t.timestamps
    end
  end
end
