class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.date :start_date
      t.date :end_date
      t.float :price
      t.integer :guests
      t.integer :user_id
      t.integer :place_id

      t.timestamps
    end
  end
end