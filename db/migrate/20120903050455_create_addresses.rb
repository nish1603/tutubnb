class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :pincode
      t.string :country
      t.integer :place_id

      t.timestamps
    end
  end
end
