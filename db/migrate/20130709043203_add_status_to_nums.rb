class AddStatusToNums < ActiveRecord::Migration
  def change
  	add_column :users, :year, :string
  	add_column :users, :status, :string
  end
end
