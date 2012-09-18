class CreatePlacesTags < ActiveRecord::Migration
  def change
    create_table :places_tags, :id => false do |t|
      t.integer :place_id
      t.integer :tag_id
    end
  end
end