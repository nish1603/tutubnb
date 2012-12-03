class CreateApiDatas < ActiveRecord::Migration
  def change
    create_table :api_datas do |t|
      t.string :url
      t.string :token
      t.string :secret
      t.integer :user_id

      t.timestamps
    end
  end
end
