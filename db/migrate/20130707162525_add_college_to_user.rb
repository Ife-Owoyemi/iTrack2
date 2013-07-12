class AddCollegeToUser < ActiveRecord::Migration
  def change
  	add_column :users, :college, :string
  	add_column :users, :dreamJob, :string
  end
end
