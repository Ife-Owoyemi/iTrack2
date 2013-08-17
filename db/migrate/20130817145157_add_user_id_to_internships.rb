class AddUserIdToInternships < ActiveRecord::Migration

	def up
		add_column :internships, :user_id, :integer
	end

	def down
		remove_column :internships, :user_id
	end


end
