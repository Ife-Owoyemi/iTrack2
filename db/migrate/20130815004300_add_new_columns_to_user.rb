class AddNewColumnsToUser < ActiveRecord::Migration
  
	def up
		add_column :users, :notesToFresh, :text
		add_column :users, :notesToMym, :text
		add_column :users, :matricuYear, :integer
		add_column :users, :postGradPlans, :string		
	end

	def down 
		remove_column :users, :notesToFresh
		remove_column :users, :notesToMym
		remove_column :users, :matricuYear
		remove_column :users, :postGradPlans
	end

end
