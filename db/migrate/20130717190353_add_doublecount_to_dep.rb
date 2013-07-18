class AddDoublecountToDep < ActiveRecord::Migration
  def change
  	add_column :depnumreqs, :doublecount, :string
  end
end
