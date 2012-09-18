class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :accomodation
      t.integer :bedrooms
      t.integer :beds
      t.string :bed_type
      t.integer :bathrooms
      t.float :size
      t.string :unit
      t.boolean :pets
      t.integer :place_id

      t.timestamps
    end
  end
end
