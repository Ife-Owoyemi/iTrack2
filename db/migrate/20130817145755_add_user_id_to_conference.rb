class AddUserIdToConference < ActiveRecord::Migration

	def up
		add_column :conferences, :user_id, :integer
	end

	def down
		remove_column :conferences, :user_id
	end

end
