class AddColumnsToUsercatalog < ActiveRecord::Migration
  def change
  	add_column :usercourses, :grade, :string
  	add_column :usercourses, :prof, :string
  	add_column :usercourses, :profquality, :integer
  	add_column :usercourses, :hpweek, :integer
  	add_column :usercourses, :follows, :string
  	add_column :usercourses, :nomidterms, :integer
  	add_column :usercourses, :noessays, :integer
  end
end
