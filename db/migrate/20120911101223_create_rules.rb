class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :rules
      t.string :availables
      t.integer :place_id

      t.timestamps
    end
  end
end
