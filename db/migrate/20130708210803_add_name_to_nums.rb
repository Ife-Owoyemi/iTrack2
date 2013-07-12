class AddNameToNums < ActiveRecord::Migration
  def change
  	add_column :nums, :name, :string
  end
end
