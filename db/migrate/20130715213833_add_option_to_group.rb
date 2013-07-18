class AddOptionToGroup < ActiveRecord::Migration
  def change
  	add_column :options, :group_id, :integer
  end
end
