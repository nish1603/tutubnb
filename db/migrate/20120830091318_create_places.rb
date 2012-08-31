class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :title
      t.text :description
      t.string :property_type
      t.string :room_type
      t.integer :user_id

      t.timestamps
    end
  end
end
