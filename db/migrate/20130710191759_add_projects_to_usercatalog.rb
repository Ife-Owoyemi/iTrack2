class AddProjectsToUsercatalog < ActiveRecord::Migration
  def change
  	add_column :usercourses, :nofinals, :integer
  end
end
