class AddOptionIdToCcourses < ActiveRecord::Migration
  def change
  	remove_column :ocourses, :opreq_id
  	add_column :ocourses, :option_id, :integer
  end
end
