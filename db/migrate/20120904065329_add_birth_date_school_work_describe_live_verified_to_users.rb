class AddBirthDateSchoolWorkDescribeLiveVerifiedToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :birth_date, :date
  	add_column :users, :school, :string
  	add_column :users, :describe, :text
  	add_column :users, :live, :string
  	add_column :users, :work, :string
  	add_column :users, :verified, :boolean, :default => false
  end
end
