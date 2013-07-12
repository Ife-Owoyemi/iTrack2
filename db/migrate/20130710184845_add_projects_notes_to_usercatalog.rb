class AddProjectsNotesToUsercatalog < ActiveRecord::Migration
  def change
  	add_column :usercourses, :nopprojects, :integer
  	add_column :usercourses, :nogprojects, :integer
  	add_column :usercourses, :suggest, :text
  end
end
